defmodule Fiscal.Http.Adapter do
  @moduledoc """
  Behaviour para clientes HTTP intercambiables, define la interfaz
  para clientes HTTP de Fiscal API.

  Proporciona una función genérica `request/3` para realizar solicitudes HTTP
  y funciones específicas para cada método HTTP común (`get/2`, `post/2`,
  `put/2`, `patch/2`, `delete/2`).

  Cada función devuelve una tupla `{:ok, response}` o `{:error, reason}`,
  donde `response` es un mapa que contiene el estado, categoría, cuerpo y
  encabezados de la respuesta.

  La categoría de estado se clasifica en `:success`, `:redirect`,
  `:client_error`, `:server_error` o `:unknown` según el código de estado HTTP.

  Esto permite a los desarrolladores gestionar las respuestas de manera coherente, independientemente del cliente HTTP subyacente utilizado.
  """

  @type method :: :get | :post | :put | :patch | :delete
  @type url :: String.t()
  @type headers :: [{String.t(), String.t()}]
  @type status_category :: :success | :redirect | :client_error | :server_error | :unknown
  @type response :: %{
          status: pos_integer(),
          category: status_category(),
          body: any(),
          headers: headers()
        }

  @callback request(method, url, keyword()) ::
              {:ok, response()} | {:error, term()}

  # Wrappers por convención
  @callback get(url, keyword()) :: {:ok, response()} | {:error, term()}
  @callback post(url, keyword()) :: {:ok, response()} | {:error, term()}
  @callback put(url, keyword()) :: {:ok, response()} | {:error, term()}
  @callback patch(url, keyword()) :: {:ok, response()} | {:error, term()}
  @callback delete(url, keyword()) :: {:ok, response()} | {:error, term()}
end
