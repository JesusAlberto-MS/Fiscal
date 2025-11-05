defmodule Fiscal do
  @moduledoc """
  Documentation for `Fiscal`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Fiscal.hello()
      :world

  """
  def hello do
    :world
  end

  require Logger

  @type environment :: :prod | :test | :dev

  @expected_environments ["prod", "test", "dev"]
  @environments %{
    "prod" => :prod,
    "test" => :test,
    "dev" => :dev
  }

  @doc """
  Expone el entorno para el que se ha compilado la aplicación.
  La intención es poder utilizar el entorno de forma global
  sin tener que acceder a la configuración de la aplicación.

  ## Ejemplo:

  ```elixir

    iex(1)> Fiscal.env()
    :test

  ```

  """
  @spec env() :: environment()
  def env do
    :fiscal
    |> Application.get_env(:env)
    |> to_atom()
  end

  defp to_atom(env) when is_atom(env), do: env

  @spec to_atom(binary()) :: environment() | atom()
  defp to_atom(env) when env in @expected_environments do
    @environments[env]
  end

  # sobelow_skip ["DOS.StringToAtom"]
  defp to_atom(env) do
    """
    Entorno no esperado:
      * entorno: #{inspect(env)}
      * entornos disponibles: #{inspect(@expected_environments)}
    """
    |> Logger.warning()

    String.to_atom(env)
  end

  @doc """
  Obtiene la versión actual de `fiscal`.

  ## Ejemplo:

  ```elixir

    iex(1)> Fiscal.version()
    "0.1.0"

  ```
  """
  def version do
    Application.spec(:fiscal)[:vsn] |> to_string()
  end

  @doc """
  Obtiene las versiones otp y elixir del sistema.
  """
  @spec version_details() :: map()
  def version_details do
    %{
      otp_version: System.otp_release(),
      elixir_version: System.version()
    }
  end
end
