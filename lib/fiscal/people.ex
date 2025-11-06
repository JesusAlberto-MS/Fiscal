defmodule Fiscal.People do
  @moduledoc """
  Módulo para gestionar personas en Fiscal API.

  Utiliza el cliente HTTP configurado en `Fiscal.Http` para realizar
  las peticiones, permitiendo usar diferentes implementaciones según
  el ambiente (HttpClient en producción, MemoryClient en tests).
  """

  alias Fiscal.Http

  @doc """
  Crea una nueva persona en Fiscal API.

  ## Parámetros
    * `attrs` - Map con los atributos de la persona
      * `:legal_name` - Nombre o razón social (requerido)
      * `:tin` - RFC/Tax ID (requerido)
      * `:email` - Email (requerido)
      * `:sat_tax_regime_id` - ID del régimen fiscal del SAT (requerido)
      * `:sat_cfdi_use_id` - ID del uso de CFDI del SAT (requerido)
      * `:zip_code` - Código postal (requerido)
      * `:password` - Contraseña (requerido)

  ## Ejemplos

      iex> Fiscal.People.create(%{
      ...>   legal_name: "INGRID XODAR JIMENEZ",
      ...>   tin: "XOJI740919U48",
      ...>   email: "ingridxodar@gmail.com",
      ...>   sat_tax_regime_id: "601",
      ...>   sat_cfdi_use_id: "G03",
      ...>   zip_code: "12345",
      ...>   password: "UserPass123456789."
      ...> })
      {:ok, %{...}}
  """
  def create(attrs) do
    client_module = Http.client()
    client = client_module.new()

    body = %{
      "legalName" => attrs[:legal_name] || attrs["legal_name"],
      "tin" => attrs[:tin] || attrs["tin"],
      "email" => attrs[:email] || attrs["email"],
      "satTaxRegimeId" => attrs[:sat_tax_regime_id] || attrs["sat_tax_regime_id"],
      "satCfdiUseId" => attrs[:sat_cfdi_use_id] || attrs["sat_cfdi_use_id"],
      "zipCode" => attrs[:zip_code] || attrs["zip_code"],
      "password" => attrs[:password] || attrs["password"]
    }

    client_module.post(client, "/people", body)
  end

  @doc """
  Obtiene una persona por ID.

  ## Parámetros
    * `person_id` - ID de la persona a consultar

  ## Ejemplos

      iex> Fiscal.People.get("person_id_123")
      {:ok, %{...}}
  """
  def get(person_id) do
    client_module = Http.client()
    client = client_module.new()

    client_module.get(client, "/people/#{person_id}")
  end

  @doc """
  Lista todas las personas.

  ## Parámetros
    * `opts` - Opciones adicionales para la petición (opcional)
      * `:page` - Número de página
      * `:limit` - Cantidad de resultados por página

  ## Ejemplos

      iex> Fiscal.People.list()
      {:ok, %{"data" => [...]}}

      iex> Fiscal.People.list(page: 2, limit: 50)
      {:ok, %{"data" => [...]}}
  """
  def list(opts \\ []) do
    client_module = Http.client()
    client = client_module.new()

    client_module.get(client, "/people", opts)
  end

  @doc """
  Actualiza una persona.

  ## Parámetros
    * `person_id` - ID de la persona
    * `attrs` - Map con los atributos a actualizar
      * `:legal_name` - Nombre o razón social (opcional)
      * `:tin` - RFC/Tax ID (opcional)
      * `:email` - Email (opcional)
      * `:sat_tax_regime_id` - ID del régimen fiscal del SAT (opcional)
      * `:sat_cfdi_use_id` - ID del uso de CFDI del SAT (opcional)
      * `:zip_code` - Código postal (opcional)

  ## Ejemplos

      iex> Fiscal.People.update("person_id_123", %{
      ...>   tin: "MASJ020408HPLRNSA0"
      ...> })
      {:ok, %{...}}

      iex> Fiscal.People.update("person_id_123", %{
      ...>   legal_name: "NUEVA RAZON SOCIAL",
      ...>   sat_tax_regime_id: "612",
      ...>   zip_code: "54321"
      ...> })
      {:ok, %{...}}
  """
  def update(person_id, attrs) do
    client_module = Http.client()
    client = client_module.new()

    # IMPORTANTE: Incluir el ID en el body
    body =
      %{
        "id" => person_id,
        "legalName" => attrs[:legal_name] || attrs["legal_name"],
        "tin" => attrs[:tin] || attrs["tin"],
        "email" => attrs[:email] || attrs["email"],
        "satTaxRegimeId" => attrs[:sat_tax_regime_id] || attrs["sat_tax_regime_id"],
        "satCfdiUseId" => attrs[:sat_cfdi_use_id] || attrs["sat_cfdi_use_id"],
        "zipCode" => attrs[:zip_code] || attrs["zip_code"],
        "password" => attrs[:password] || attrs["password"]
      }
      |> Enum.reject(fn {k, v} -> k != "id" && is_nil(v) end)
      |> Map.new()

    client_module.put(client, "/people/#{person_id}", body)
  end

  @doc """
  Elimina una persona.

  ## Parámetros
    * `person_id` - ID de la persona a eliminar

  ## Ejemplos

      iex> Fiscal.People.delete("person_id_123")
      {:ok, %{...}}
  """
  def delete(person_id) do
    client_module = Http.client()
    client = client_module.new()

    client_module.delete(client, "/people/#{person_id}")
  end
end
