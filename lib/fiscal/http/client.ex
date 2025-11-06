defmodule Fiscal.Http.Client do
  @moduledoc """
  Behaviour que define la interfaz para clientes HTTP de Fiscal API.
  """

  @type response() ::
          {:ok, term()}
          | {:error, %{status: integer(), message: String.t(), body: term()}}
          | {:error, %{message: String.t()}}

  @type client() :: Req.Request.t()

  @doc """
  Crea un nuevo cliente HTTP configurado.
  """
  @callback new(opts :: keyword()) :: client()

  @doc """
  Realiza una petición GET.
  """
  @callback get(client :: client(), path :: String.t(), opts :: keyword()) :: response()

  @doc """
  Realiza una petición POST.
  """
  @callback post(client :: client(), path :: String.t(), body :: map(), opts :: keyword()) ::
              response()

  @doc """
  Realiza una petición PUT.
  """
  @callback put(client :: client(), path :: String.t(), body :: map(), opts :: keyword()) ::
              response()

  @doc """
  Realiza una petición DELETE.
  """
  @callback delete(client :: client(), path :: String.t(), opts :: keyword()) :: response()
end
