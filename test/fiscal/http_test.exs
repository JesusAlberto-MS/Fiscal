defmodule Fiscal.HttpTest do
  use ExUnit.Case
  doctest Fiscal.Http
  alias Fiscal.Http

  @base_url "http://localhost"

  test "GET 200 -> :success y body JSON" do
    {:ok, res} = Http.get("#{@base_url}/ping")
    assert res.category == :success
    assert res.body == "{\"msg\":\"pong\"}"
  end

  test "404 -> :client_error" do
    {:ok, res} = Http.get("#{@base_url}/nope")
    assert res.category == :client_error
    assert res.status == 418
  end

  test "500 -> :server_error" do
    {:ok, res} = Http.get("#{@base_url}/fail")
    assert res.category == :server_error
  end

  test "headers y body enviados correctamente" do
    {:ok, res} =
      Http.post("#{@base_url}/echo", json: %{msg: "hello"}, headers: [{"x-api-key", "123"}])

    message = Jason.decode!(res.body)

    assert res.status == 201
    assert res.category == :success
    assert %{"echo" => %{"msg" => "hello"}} = message
  end
end
