defmodule Fiscal.Http do
  @moduledoc """
  Encapsula la lógica relacionada con la generación de peticiones HTTP
  para Fiscal API.

  Este módulo actúa como punto de entrada para obtener la configuración
  y el cliente HTTP que se utilizará en toda la aplicación.
  """

  @doc """
  Función que obtiene un arreglo de la configuración definida para
  la aplicación.

  Por ejemplo, cuando se define en el archivo de configuración lo
  siguiente:
  ```elixir
  config :fiscal, Fiscal.Http,
    client: Fiscal.Http.HttpClient
  ```

  Se puede obtener la configuración con la siguiente instrucción:
  ```elixir
  iex> Fiscal.Http.config()
  [client: Fiscal.Http.MemoryClient]
  ```

  """
  def config do
    Application.get_env(:fiscal, Fiscal.Http, default_config())
  end

  @doc """
  Obtiene el módulo definido como cliente para el entorno en el que se está
  ejecutando el sistema.

  ## Ejemplo:

  En ambiente de pruebas:
  ```elixir
  iex> Fiscal.Http.client()
  Fiscal.Http.MemoryClient
  ```

  En ambiente de producción retornaría:
  ```
  Fiscal.Http.HttpClient
  ```

  """
  def client, do: config()[:client]

  # Configuración por defecto
  defp default_config do
    [
      client: Fiscal.Http.HttpClient
    ]
  end
end
