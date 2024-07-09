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

  defp handle_result({:error, :already_canceled}) do
    {:error, Error.build(:bad_request, "parcel is already canceled")}
  end

  defp handle_result({:error, :already_in_transit}) do
    {:error, Error.build(:bad_request, "parcel is already in transit")}
  end

  defp handle_result({:error, :already_delivered}) do
    {:error, Error.build(:bad_request, "parcel is already delivered")}
  end
end
