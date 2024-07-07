defmodule ParcelManager.Application.UseCases.TransferParcel do
  @moduledoc false

  use ParcelManager.Application.UseCases.Macro

  alias ParcelManager.Infrastructure.Persistence.Repo
  alias ParcelManager.Infrastructure.Mailer.Workers.SenderWorker

  @type use_case_output ::
          {:ok, Schemas.Parcel.t()}
          | {:error,
             :parcel_not_found
             | :location_not_found
             | :already_delivered
             | :cannot_be_returned_to_previous_locations}

  @spec call(dto :: Dtos.TransferParcel.t()) :: use_case_output()
  def call(%Dtos.TransferParcel{} = dto) do
    Logger.info(
      "#{__MODULE__}.call parcel_id=#{dto.parcel_id} transfer_location_id=#{dto.transfer_location_id}"
    )

    Ecto.Multi.new()
    |> Ecto.Multi.put(:dto, dto)
    |> Ecto.Multi.one(:parcel, &Entities.Parcel.with_transfers(&1.dto.parcel_id))
    |> Ecto.Multi.one(:location, &Entities.Location.by_id(&1.dto.transfer_location_id))
    |> Ecto.Multi.run(:transfer_parcel, &transfer_parcel/2)
    |> Ecto.Multi.run(:sent_email, &maybe_send_email/2)
    |> Repo.transaction(telemetry_options: [name: :transfer_parcel_transaction])
    |> handle_result()
  end

  defp transfer_parcel(_, %{parcel: nil}), do: {:error, :parcel_not_found}
  defp transfer_parcel(_, %{location: nil}), do: {:error, :location_not_found}

  defp transfer_parcel(_, %{parcel: parcel, location: location}) do
    Aggregates.Transfer.transfer_parcel(parcel, location)
  end

  defp maybe_send_email(_, %{transfer_parcel: %{update_parcel: :skipped}}) do
    {:ok, :skipped}
  end

  defp maybe_send_email(_, _) do
    %{message: "Parcel is delivered sucessfully!"}
    |> SenderWorker.new()
    |> Oban.insert()
  end

  defp handle_result({:error, _, reason, _}), do: {:error, reason}
  defp handle_result({:ok, result}), do: {:ok, result}
end
