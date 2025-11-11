defmodule Fiscal.Http do
  @moduledoc """
  Fachada pública para el cliente HTTP de Fiscal.
  Encapsula la lógica relacionada con la generación de peticiones HTTP
  para Fiscal API.

  Este módulo actúa como punto de entrada para obtener la configuración
  y el cliente HTTP que se utilizará en toda la aplicación.

  Por defecto usa `Fiscal.Http.HttpClient`, pero se puede
  inyectar otra implementación mediante configuración o argumento.
  """

  @client Application.compile_env(:fiscal, Fiscal.Http, client: Fiscal.Http.HttpClient)[:client]

  @spec request(atom(), String.t(), keyword()) :: {:ok, map()} | {:error, term()}
  def request(method, url, opts \\ []), do: @client.request(method, url, opts)

  def get(url, opts \\ []), do: @client.get(url, opts)
  def post(url, opts \\ []), do: @client.post(url, opts)
  def put(url, opts \\ []), do: @client.put(url, opts)
  def patch(url, opts \\ []), do: @client.patch(url, opts)
  def delete(url, opts \\ []), do: @client.delete(url, opts)
end
