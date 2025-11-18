defmodule Mix.Tasks.Fiscal.Gen.PayloadsTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  alias Mix.Tasks.Fiscal.Gen.Payloads

  describe "run/1" do
    test "sin argumentos muestra las instrucciones y lanza error" do
      assert_raise Mix.Error, ~r/Este task necesita parámetros/, fn ->
        Payloads.run()
      end
    end

    test "con nil muestra las instrucciones y lanza error" do
      assert_raise Mix.Error, ~r/Este task necesita parámetros/, fn ->
        Payloads.run(nil)
      end
    end

    test "con lista vacía muestra las instrucciones y lanza error" do
      assert_raise Mix.Error, ~r/Este task necesita parámetros/, fn ->
        Payloads.run([])
      end
    end

    test "con --person genera el payload correctamente" do
      output =
        capture_io(fn ->
          Payloads.run(["--person"])
        end)

      assert output =~ "✅ Payload generado exitosamente:"
      assert output =~ "\"legal_name\": \"Nombre o Razón Social de Ejemplo\""
      assert output =~ "\"tin\": \"XAXX010101000\""
      assert output =~ "\"email\": \"ejemplo@correo.com\""
      assert output =~ "\"sat_tax_regime_id\": \"601\""
      assert output =~ "\"sat_cfdi_use_id\": \"G03\""
      assert output =~ "\"zip_code\": \"12345\""
      assert output =~ "\"password\": \"ContraseniaSegura123.\""
    end

    test "con -p genera el payload correctamente" do
      output =
        capture_io(fn ->
          Payloads.run(["-p"])
        end)

      assert output =~ "✅ Payload generado exitosamente:"
      assert output =~ "\"legal_name\""
    end

    test "con --help muestra la ayuda" do
      instructions = """
      Uso: mix fiscal.gen.payloads [opciones]

      Opciones:
        -p, --person    Genera un payload de ejemplo para persona
        -h, --help      Muestra esta ayuda

      Ejemplos:
        mix fiscal.gen.payloads --person
        mix fiscal.gen.payloads -p
      """

      output =
        capture_io(fn ->
          Payloads.run(["--help"])
        end)

      assert output =~ instructions
    end

    test "con -h muestra la ayuda" do
      output =
        capture_io(fn ->
          Payloads.run(["-h"])
        end)

      assert output =~ "Uso: mix fiscal.gen.payloads [opciones]"
    end

    test "con opción no reconocida muestra error" do
      assert_raise Mix.Error, ~r/Se requiere una opción para generar el payload/, fn ->
        capture_io(fn ->
          Payloads.run(["--invalid"])
        end)
      end
    end

    test "con argumentos inválidos muestra error" do
      output =
        capture_io(fn ->
          # Cuando hay un argumento inválido, show_error se ejecuta
          # pero luego execute puede lanzar Mix.Error
          try do
            Payloads.run(["--person=invalid"])
          rescue
            Mix.Error -> :ok
          end
        end)

      # Verifica que se mostró el help por el error
      assert output =~ "--------------------------------------------"
      assert output =~ "Uso: mix fiscal.gen.payloads"
    end
  end

  describe "parse/1" do
    test "parsea correctamente --person" do
      {switches, args, invalid} = Payloads.parse(["--person"])

      assert switches == [person: true]
      assert args == []
      assert invalid == []
    end

    test "parsea correctamente -p" do
      {switches, args, invalid} = Payloads.parse(["-p"])

      assert switches == [person: true]
      assert args == []
      assert invalid == []
    end

    test "parsea correctamente --help" do
      {switches, args, invalid} = Payloads.parse(["--help"])

      assert switches == [help: true]
      assert args == []
      assert invalid == []
    end

    test "parsea correctamente -h" do
      {switches, args, invalid} = Payloads.parse(["-h"])

      assert switches == [help: true]
      assert args == []
      assert invalid == []
    end

    test "detecta opciones inválidas" do
      {switches, args, invalid} = Payloads.parse(["--invalid"])

      assert switches == [invalid: true]
      assert args == []
      assert invalid == []
    end

    test "detecta valores inválidos en switches booleanos" do
      {switches, _args, invalid} = Payloads.parse(["--person=value"])

      assert switches == []
      assert invalid == [{"--person", "value"}]
    end
  end

  describe "evaluate_switches/1" do
    test "retorna switches cuando son válidos y no vacíos" do
      input = {[person: true], [], []}
      result = Payloads.evaluate_switches(input)

      assert result == [person: true]
    end

    test "retorna switches con help cuando es válido" do
      input = {[help: true], [], []}
      result = Payloads.evaluate_switches(input)

      assert result == [help: true]
    end

    test "retorna args cuando switches está vacío pero args no" do
      input = {[], ["arg1"], []}
      result = Payloads.evaluate_switches(input)

      assert result == ["arg1"]
    end

    test "muestra error cuando hay argumentos inválidos" do
      input = {[person: true], [], [{"--invalid", nil}]}

      output =
        capture_io(fn ->
          Payloads.evaluate_switches(input)
        end)

      assert output =~ "[person: true]"
      assert output =~ "--------------------------------------------"
      assert output =~ "Uso: mix fiscal.gen.payloads"
    end
  end

  describe "instructions/0" do
    test "retorna las instrucciones correctas" do
      instructions = Payloads.instructions()

      assert instructions =~ "Este task necesita parámetros"
      assert instructions =~ "mix help fiscal.gen.payloads"
    end
  end

  describe "integración completa" do
    test "flujo completo de generación de payload de persona" do
      output =
        capture_io(fn ->
          Payloads.run(["--person"])
        end)

      # Verifica que el JSON sea válido
      json_start = String.split(output, "\n", parts: 2) |> List.last()
      assert {:ok, decoded} = Jason.decode(json_start)

      # Verifica los campos esperados
      assert decoded["legal_name"] == "Nombre o Razón Social de Ejemplo"
      assert decoded["tin"] == "XAXX010101000"
      assert decoded["email"] == "ejemplo@correo.com"
      assert decoded["sat_tax_regime_id"] == "601"
      assert decoded["sat_cfdi_use_id"] == "G03"
      assert decoded["zip_code"] == "12345"
      assert decoded["password"] == "ContraseniaSegura123."
    end

    test "flujo completo con alias -p" do
      output =
        capture_io(fn ->
          Payloads.run(["-p"])
        end)

      assert output =~ "✅ Payload generado exitosamente:"

      # Extrae y valida el JSON
      json_start = String.split(output, "\n", parts: 2) |> List.last()
      assert {:ok, _decoded} = Jason.decode(json_start)
    end

    test "flujo completo mostrando ayuda" do
      instructions = """
      Uso: mix fiscal.gen.payloads [opciones]

      Opciones:
        -p, --person    Genera un payload de ejemplo para persona
        -h, --help      Muestra esta ayuda

      Ejemplos:
        mix fiscal.gen.payloads --person
        mix fiscal.gen.payloads -p
      """

      output =
        capture_io(fn ->
          Payloads.run(["--help"])
        end)

      assert output =~ instructions
    end
  end

  describe "manejo de errores" do
    test "error cuando no se proporciona ninguna opción válida" do
      assert_raise Mix.Error, ~r/Se requiere una opción para generar el payload/, fn ->
        capture_io(fn ->
          Payloads.run(["--unknown"])
        end)
      end
    end

    test "error con instrucciones cuando hay argumentos inválidos" do
      output =
        capture_io(fn ->
          Payloads.evaluate_switches({[], [], [{"--bad", "value"}]})
        end)

      assert output =~ "--------------------------------------------"
      assert output =~ "Uso: mix fiscal.gen.payloads"
    end
  end
end
