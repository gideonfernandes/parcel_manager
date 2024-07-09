defmodule ParcelManager.Application.UseCases.TransferParcel do
  @moduledoc false

  use ParcelManager.Application.UseCases.Macro

  alias ParcelManager.Infrastructure.Mailer.Workers.SenderWorker
  alias ParcelManager.Infrastructure.Persistence.Repo

  @type use_case_output :: {:ok, map()} | {:error, Error.t()}

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
    |> Ecto.Multi.run(:email, &maybe_send_email/2)
    |> Repo.transaction(telemetry_options: [name: :transfer_parcel_transaction])
    |> handle_result()
  end

  defp transfer_parcel(_, %{parcel: nil}), do: {:error, :parcel_not_found}
  defp transfer_parcel(_, %{location: nil}), do: {:error, :location_not_found}

  defp transfer_parcel(_, %{parcel: parcel, location: location}) do
    Aggregates.Transfer.transfer_parcel(parcel, location)
  end

  defp maybe_send_email(_, %{transfer_parcel: %{update_parcel: %{state: :delivered}}}) do
    %{message: "Parcel is delivered sucessfully!"}
    |> SenderWorker.new()
    |> Oban.insert()
  end

  defp maybe_send_email(_, _) do
    {:ok, :skipped}
  end

  defp handle_result({:ok, result}), do: {:ok, result}

  defp handle_result({:error, _, %Ecto.Changeset{} = changeset, _}) do
    Logger.error("#{__MODULE__}.call changeset_errors=#{inspect(changeset.errors)}")

    handle_result({:error, changeset})
  end

  defp handle_result({:error, _, reason, _}) do
    Logger.error("#{__MODULE__}.call #{inspect(reason)}")

    handle_result({:error, reason})
  end

  defp handle_result({:error, %Ecto.Changeset{} = changeset}) do
    {:error, Error.build(:bad_request, changeset)}
  end

  defp handle_result({:error, :parcel_not_found}) do
    {:error, Error.build(:not_found, "parcel not found")}
  end

  defp handle_result({:error, :location_not_found}) do
    {:error, Error.build(:not_found, "location not found")}
  end

  defp handle_result({:error, :already_delivered}) do
    {:error, Error.build(:bad_request, "parcel is already delivered")}
  end

  defp handle_result({:error, :cannot_be_transferred_to_current_location}) do
    {:error, Error.build(:bad_request, "parcel cannot be transferred to current location")}
  end

  defp handle_result({:error, :cannot_be_returned_to_previous_locations}) do
    {:error, Error.build(:bad_request, "parcel cannot be returned to previous locations")}
  end
end
