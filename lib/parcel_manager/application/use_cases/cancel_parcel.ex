defmodule ParcelManager.Application.UseCases.CancelParcel do
  @moduledoc false

  use ParcelManager.Application.UseCases.Macro

  alias ParcelManager.Infrastructure.Mailer.Workers.SenderWorker
  alias ParcelManager.Infrastructure.Persistence.Repo
  alias ParcelManager.Infrastructure.Persistence.Schemas

  @type use_case_output :: {:ok, Schemas.Parcel.t()} | {:error, Error.t()}

  @spec call(dto :: Dtos.CancelParcel.t()) :: use_case_output()
  def call(%Dtos.CancelParcel{} = dto) do
    Logger.info("#{__MODULE__}.call parcel_id=#{dto.parcel_id}")

    Ecto.Multi.new()
    |> Ecto.Multi.put(:dto, dto)
    |> Ecto.Multi.one(:parcel, &Entities.Parcel.by_id(&1.dto.parcel_id))
    |> Ecto.Multi.run(:cancel_parcel, &cancel_parcel/2)
    |> Ecto.Multi.run(:email, &send_email/2)
    |> Repo.transaction(telemetry_options: [name: :cancel_parcel_transaction])
    |> handle_result()
  end

  defp cancel_parcel(_, %{parcel: nil}), do: {:error, :parcel_not_found}

  defp cancel_parcel(_, %{dto: dto, parcel: parcel}) do
    with {:ok, true} <- Entities.Parcel.check_cancelability(parcel) do
      Entities.Parcel.cancel(parcel, %{reason: dto.reason})
    end
  end

  defp send_email(_, _) do
    %{message: "Parcel is canceled sucessfully!"}
    |> SenderWorker.new()
    |> Oban.insert()
  end

  defp handle_result({:ok, result}), do: {:ok, result}

  defp handle_result({:error, _, :parcel_not_found, _}) do
    {:error, Error.build(:not_found, "parcel not found")}
  end

  defp handle_result({:error, _, :already_canceled, _}) do
    {:error, Error.build(:bad_request, "parcel is already canceled")}
  end

  defp handle_result({:error, _, :already_in_transit, _}) do
    {:error, Error.build(:bad_request, "parcel is already in transit")}
  end

  defp handle_result({:error, _, :already_delivered, _}) do
    {:error, Error.build(:bad_request, "parcel is already delivered")}
  end

  defp handle_result({:error, %Ecto.Changeset{} = changeset}) do
    {:error, Error.build(:bad_request, changeset)}
  end
end
