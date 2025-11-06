defmodule Fiscal.Http.HttpClient do
  @moduledoc """
  Implementación del comportamiento `Fiscal.Http.Client`.
  Cliente HTTP base para interactuar con Fiscal API.
  Maneja la autenticación y configuración de headers.
  """

  @behaviour Fiscal.Http.Client

  @impl true
  def new(opts \\ []) do
    base_url = Application.get_env(:fiscal, :base_url)
    api_key = Application.get_env(:fiscal, :api_key)
    tenant_key = Application.get_env(:fiscal, :tenant_key)

    headers =
      [
        {"X-API-KEY", api_key},
        {"X-TENANT-KEY", tenant_key},
        {"Content-Type", "application/json"}
      ] ++ opts

    Req.new(
      base_url: base_url,
      headers: headers
    )
  end

  @impl true
  def get(client, path, opts \\ []) do
    merged_opts = Keyword.merge(opts, url: path)

    case Req.get(client, merged_opts) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Req.Response{status: status, body: body}} ->
        {:error, %{status: status, message: "HTTP #{status}", body: body}}

      {:error, exception} ->
        {:error, %{message: Exception.message(exception)}}
    end
  end

  @impl true
  def post(client, path, body, opts \\ []) do
    merged_opts = Keyword.merge(opts, url: path, json: body)

    case Req.post(client, merged_opts) do
      {:ok, %Req.Response{status: status, body: response_body}} when status in 200..299 ->
        {:ok, response_body}

      {:ok, %Req.Response{status: status, body: body}} ->
        {:error, %{status: status, message: "HTTP #{status}", body: body}}

      {:error, exception} ->
        {:error, %{message: Exception.message(exception)}}
    end
  end

  @impl true
  def put(client, path, body, opts \\ []) do
    merged_opts = Keyword.merge(opts, url: path, json: body)

    case Req.put(client, merged_opts) do
      {:ok, %Req.Response{status: status, body: response_body}} when status in 200..299 ->
        {:ok, response_body}

      {:ok, %Req.Response{status: status, body: body}} ->
        {:error, %{status: status, message: "HTTP #{status}", body: body}}

      {:error, exception} ->
        {:error, %{message: Exception.message(exception)}}
    end
  end

  @impl true
  def delete(client, path, opts \\ []) do
    merged_opts = Keyword.merge(opts, url: path)

    case Req.delete(client, merged_opts) do
      {:ok, %Req.Response{status: status, body: body}} when status in 200..299 ->
        {:ok, body}

      {:ok, %Req.Response{status: status, body: body}} ->
        {:error, %{status: status, message: "HTTP #{status}", body: body}}

      {:error, exception} ->
        {:error, %{message: Exception.message(exception)}}
    end
  end
end
