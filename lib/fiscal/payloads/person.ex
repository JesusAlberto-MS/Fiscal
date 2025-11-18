defmodule Fiscal.Payloads.Person do
  @moduledoc """
  Estructura y validaciones para el payload de creación de una persona
  en la API de Fiscal.

  ## Campos

    * `legal_name` - Nombre o razón social de la persona (requerido)
    * `tin` - RFC o Tax ID
    * `email` - Correo electrónico de la persona (requerido)
    * `sat_tax_regime_id` - ID del régimen fiscal SAT
    * `sat_cfdi_use_id` - ID del uso de CFDI SAT
    * `zip_code` - Código postal
    * `password` - Contraseña para la cuenta (requerido)

  ## Ejemplo de uso

      iex> json_payload = ~s({
      ...>   "legal_name": "Nombre o Razón Social de Ejemplo",
      ...>   "password": "SecurePassword123.",
      ...>   "email": "email@sample.com"})
      iex> {:ok, person} = Fiscal.Payloads.Person.parse(json_payload)
      iex> person.legal_name
      "Nombre o Razón Social de Ejemplo"

  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:legal_name, :email, :password]

  @fields [
            :tin,
            :sat_tax_regime_id,
            :sat_cfdi_use_id,
            :zip_code
          ] ++ @required_fields

  @derive {Jason.Encoder, only: @fields}

  embedded_schema do
    field(:legal_name, :string)
    field(:tin, :string)
    field(:email, :string)
    field(:sat_tax_regime_id, :string)
    field(:sat_cfdi_use_id, :string)
    field(:zip_code, :string)
    field(:password, :string)
  end

  def changeset(data, attrs) do
    data
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end

  # Punto de entrada: recibe JSON y devuelve struct o {:error, changeset}
  def parse(json_string) when is_binary(json_string) do
    with {:ok, attrs} <- Jason.decode(json_string),
         attrs <- underscore_keys(attrs),
         changeset <- __MODULE__.changeset(%__MODULE__{}, attrs) do
      if changeset.valid? do
        {:ok, apply_changes(changeset)}
      else
        {:error, changeset}
      end
    end
  end

  # Convierte camelCase -> snake_case sólo para el primer nivel
  defp underscore_keys(map) do
    map
    |> Enum.map(fn {k, v} -> {Macro.underscore(k), v} end)
    |> Enum.into(%{})
  end
end
