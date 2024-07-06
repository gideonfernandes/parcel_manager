defmodule ParcelManager.Application.Dtos.Macro do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset

      @primary_key false
      @before_compile ParcelManager.Application.Dtos.Macro
    end
  end

  defmacro __before_compile__(%Macro.Env{module: module}) do
    should_generate_build? = Module.defines?(module, {:changeset, 2})

    quote generated: true do
      if unquote(should_generate_build?) do
        @spec build(attrs :: map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
        def build(attrs) do
          %__MODULE__{}
          |> changeset(attrs)
          |> apply_action(:create)
        end
      end
    end
  end
end
