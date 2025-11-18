defmodule Mix.Tasks.Fiscal.Gen.Payloads do
  @moduledoc """
  Genera payloads JSON de ejemplo para facilitar la interacción
  con la API de Fiscal.

  ## Ejemplos

  ```elixir
  mix fiscal.gen.payloads -p

  mix fiscal.gen.payloads --person
  ```

  ## Opciones de línea de comando

  * `-p`, `--person` - genera un payload de ejemplo para persona (requerido)
  * `-h`, `--help`   - muestra esta ayuda
  """

  use Mix.Task

  alias Fiscal.Payloads.Person

  @shortdoc "Genera payloads JSON de ejemplo para los servicios de Fiscal API."

  @spec instructions() :: binary()
  def instructions do
    """
    Este task necesita parámetros, ejecuta el siguiente comando para ver la ayuda.

    mix help fiscal.gen.payloads
    """
  end

  @spec run() :: none()
  def run, do: Mix.raise(instructions())

  @impl Mix.Task
  @spec run([binary(), ...]) :: any()
  def run(nil), do: Mix.raise(instructions())
  def run([]), do: Mix.raise(instructions())

  def run(args) do
    args
    |> parse()
    |> evaluate_switches()
    |> execute()
  end

  def parse(args) do
    switches = [
      person: :boolean,
      help: :boolean
    ]

    aliases = [p: :person, h: :help]

    OptionParser.parse(args, switches: switches, aliases: aliases)
  end

  def evaluate_switches({switches, args, invalid}) do
    valid? = valid?(invalid)

    cond do
      not valid? -> show_error(switches)
      valid? and length(switches) > 0 -> switches
      valid? and length(args) > 0 -> args
    end
  end

  defp valid?(input) do
    case input do
      nil -> true
      input when is_list(input) -> input == []
      _ -> Mix.shell().error("Inválido: #{inspect(input)}")
    end
  end

  defp show_error(input) do
    Mix.shell().info("\t#{inspect(input)}")
    Mix.shell().info("--------------------------------------------")
    show_help()
  end

  defp show_help do
    Mix.shell().info("""
    Uso: mix fiscal.gen.payloads [opciones]

    Opciones:
      -p, --person    Genera un payload de ejemplo para persona
      -h, --help      Muestra esta ayuda

    Ejemplos:
      mix fiscal.gen.payloads --person
      mix fiscal.gen.payloads -p
    """)
  end

  defp execute(switches) when is_list(switches) do
    cond do
      Keyword.get(switches, :help) ->
        show_help()

      Keyword.get(switches, :person) ->
        generate_person_payload()

      true ->
        Mix.raise(
          "Se requiere una opción para generar el payload (ej: --person o mix help fiscal.gen.payloads)."
        )
    end
  end

  defp execute(_), do: Mix.raise(instructions())

  defp generate_person_payload do
    person = %Person{
      legal_name: "Nombre o Razón Social de Ejemplo",
      tin: "XAXX010101000",
      email: "ejemplo@correo.com",
      sat_tax_regime_id: "601",
      sat_cfdi_use_id: "G03",
      zip_code: "12345",
      password: "ContraseniaSegura123."
    }

    case Jason.encode(person, pretty: true) do
      {:ok, json_data} ->
        Mix.shell().info("✅ Payload generado exitosamente:\n")
        Mix.shell().info(json_data)

      {:error, reason} ->
        Mix.shell().error("❌ Error al serializar el payload a JSON: #{inspect(reason)}")
    end
  end
end
