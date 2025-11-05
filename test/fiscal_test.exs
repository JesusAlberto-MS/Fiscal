defmodule FiscalTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  doctest Fiscal

  test "greets the world" do
    assert Fiscal.hello() == :world
  end

  @allowed_environments %{
    "prod" => :prod,
    "test" => :test,
    "dev" => :dev
  }

  describe "Fiscal.env/0" do
    setup %{env: env, expected: expected} do
      previous = Application.get_env(:fiscal, :env)
      Application.put_env(:fiscal, :env, env)

      on_exit(fn ->
        Application.put_env(:fiscal, :env, previous)
      end)

      {:ok, expected: expected}
    end

    for {env_key, expected} <- @allowed_environments do
      @env_key env_key
      @expected expected

      @tag env: @env_key, expected: @expected
      test "when application env is #{@env_key}", %{expected: expected} do
        data = Fiscal.env()
        assert expected == data
      end
    end

    @tag env: "not_expected", expected: :not_expected
    test "when application env is not expected", %{expected: expected} do
      fun = fn ->
        assert expected == Fiscal.env()
      end

      assert capture_log(fun) =~ "Entorno no esperado"
    end
  end
end
