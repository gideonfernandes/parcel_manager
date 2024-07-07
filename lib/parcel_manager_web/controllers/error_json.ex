defmodule ParcelManagerWeb.ErrorJSON do
  @moduledoc false

  @spec render(String.t(), map()) :: map()
  def render("error.json", %{result: %Ecto.Changeset{} = changeset}) do
    %{reason: translate_errors(changeset)}
  end

  def render("error.json", %{result: result}), do: %{reason: result}

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
