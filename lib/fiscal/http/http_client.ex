defmodule Fiscal.Http.HttpClient do
  @moduledoc """
  Implementación del comportamiento `Fiscal.Http.Adapter`.
  Cliente HTTP base para interactuar con Fiscal API.
  Maneja la autenticación y configuración de headers.

  Utiliza la biblioteca `Req` para realizar solicitudes HTTP.
  Proporciona una función genérica `request/3` y funciones específicas
  para cada método HTTP común (`get/2`, `post/2`, `put/2`, `patch/2`, `delete/2`).

  Este módulo *no se usa directamente*, sino que sirve como base para otros
  clientes HTTP específicos que pueden extender o modificar su comportamiento.

  """

  @behaviour Fiscal.Http.Adapter

  require Logger

  @doc """
  Realiza una solicitud HTTP genérica.
  Acepta el método HTTP, la URL y opciones adicionales.
  Devuelve una tupla `{:ok, response}` o `{:error, reason}`.

  Las opciones pueden incluir:
    - `:base_url` - URL base para la solicitud.
    - `:finch_name` - Nombre del pool de Finch a usar.
    - `:headers` - Encabezados HTTP adicionales.
    - `:json` - Cuerpo JSON para solicitudes POST/PUT/PATCH.
    - `:body` - Cuerpo bruto para la solicitud.
    - `:query` - Parámetros de consulta para la URL.
    - `:timeout` - Tiempo de espera para la solicitud.
    - `:recv_timeout` - Tiempo de espera para recibir la respuesta.

  """

  @request_options [:json, :body, :query, :timeout, :recv_timeout]

  @impl true
  def request(method, url, opts \\ []) when is_atom(method) do
    req = build_request(opts)

    req_opts =
      opts
      |> Keyword.take(@request_options)
      |> Keyword.merge(method: method, url: url)

    case Req.request(req, req_opts) do
      {:ok, %Req.Response{status: status, body: body, headers: headers}} ->
        {:ok, build_response_map(status, body, headers)}

      {:error, exception} ->
        # Mandamos log en debug para facilitar diagnóstico en entornos dev
        """
        Method: #{inspect(method)}
        Url: #{inspect(url)}
        Exception: #{Exception.message(exception)}
        """
        |> Logger.debug()

        {:error, {:http_exception, exception}}
    end
  end

  defp build_request(opts) do
    options = [
      base_url: Keyword.get(opts, :base_url),
      finch: Keyword.get(opts, :finch_name) || FiscalFinch,
      headers: Keyword.get(opts, :headers, [])
    ]

    adapter = Keyword.get(opts, :adapter)

    options
    |> add_adapter(adapter)
    |> Req.new()
  end

  defp add_adapter(opts, nil), do: opts

  defp add_adapter(opts, adapter) when is_atom(adapter) do
    opts ++ [adapter: &adapter.run/1]
  end

  defp add_adapter(opts, adapter), do: opts ++ [adapter: adapter]

  defp build_response_map(status, body, headers) do
    %{
      status: status,
      category: status_category(status),
      body: decode_body(body),
      headers: headers
    }
  end

  defp status_category(status) when status >= 200 and status < 300, do: :success
  defp status_category(status) when status >= 300 and status < 400, do: :redirect
  defp status_category(status) when status >= 400 and status < 500, do: :client_error
  defp status_category(status) when status >= 500 and status < 600, do: :server_error
  defp status_category(_), do: :unknown

  defp decode_body(body) when is_binary(body) do
    case Jason.decode(body) do
      {:ok, decoded} -> decoded
      _ -> body
    end
  end

  defp decode_body(body), do: body

  # Implementaciones por conveniencia
  @doc """
  Realiza una solicitud HTTP GET.
  Ver `request/3` para detalles de opciones y retorno.
  """
  @impl true
  def get(url, opts \\ []), do: request(:get, url, opts)

  @doc """
  Realiza una solicitud HTTP POST.
  Ver `request/3` para detalles de opciones y retorno.
  """
  @impl true
  def post(url, opts \\ []), do: request(:post, url, opts)

  @doc """
  Realiza una solicitud HTTP PUT.
  Ver `request/3` para detalles de opciones y retorno.
  """
  @impl true
  def put(url, opts \\ []), do: request(:put, url, opts)

  @doc """
  Realiza una solicitud HTTP PATCH.
  Ver `request/3` para detalles de opciones y retorno.
  """
  @impl true
  def patch(url, opts \\ []), do: request(:patch, url, opts)

  @doc """
  Realiza una solicitud HTTP DELETE.
  Ver `request/3` para detalles de opciones y retorno.
  """
  @impl true
  def delete(url, opts \\ []), do: request(:delete, url, opts)
end
