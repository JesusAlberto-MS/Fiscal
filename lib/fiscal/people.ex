defmodule Fiscal.People do
  @moduledoc """
  Módulo para gestionar personas en Fiscal API.

  Utiliza el cliente HTTP configurado en `Fiscal.Http` para realizar
  las peticiones, permitiendo usar diferentes implementaciones según
  el ambiente (HttpClient en producción, MemoryClient en tests).
  """
  alias Fiscal.Http

  @base_url Application.compile_env(:fiscal, :base_url)
  @api_key Application.compile_env(:fiscal, :api_key)
  @tenant_key Application.compile_env(:fiscal, :tenant_key)

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
    headers = build_headers()
    body = build_body(attrs)

    case Http.post("/people", base_url: @base_url, headers: headers, json: body) do
      {:ok, %{body: response_body}} ->
        {:ok, response_body}

      {:error, reason} ->
        {:error, reason}
    end
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
    headers = build_headers()

    case Http.get("/people/#{person_id}",
           base_url: @base_url,
           headers: headers
         ) do
      {:ok, %{body: response_body}} ->
        {:ok, response_body}

      {:error, reason} ->
        {:error, reason}
    end
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
    headers = build_headers()

    body =
      build_body(attrs)
      |> Map.merge(%{"id" => person_id})
      |> Enum.reject(fn {k, v} -> k != "id" && is_nil(v) end)
      |> Map.new()

    case Http.put("/people/#{person_id}",
           base_url: @base_url,
           headers: headers,
           json: body
         ) do
      {:ok, %{body: response_body}} ->
        {:ok, response_body}

      {:error, reason} ->
        {:error, reason}
    end
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
    headers = build_headers()

    case Http.delete("/people/#{person_id}",
           base_url: @base_url,
           headers: headers
         ) do
      {:ok, %{body: response_body}} ->
        {:ok, response_body}

      {:error, reason} ->
        {:error, reason}
    end
  end

  # Función helper para construir headers comunes
  defp build_headers do
    [
      {"X-API-KEY", @api_key},
      {"X-TENANT-KEY", @tenant_key},
      {"Content-Type", "application/json"}
    ]
  end

  # Helper para obtener un atributo usando clave de átomo o string
  defp get_attr(attrs, key) do
    attrs[key] || attrs[Atom.to_string(key)]
  end

  # Construye el body para crear una persona
  defp build_body(attrs) do
    %{
      "legalName" => get_attr(attrs, :legal_name),
      "tin" => get_attr(attrs, :tin),
      "email" => get_attr(attrs, :email),
      "satTaxRegimeId" => get_attr(attrs, :sat_tax_regime_id),
      "satCfdiUseId" => get_attr(attrs, :sat_cfdi_use_id),
      "zipCode" => get_attr(attrs, :zip_code),
      "password" => get_attr(attrs, :password)
    }
  end
end
