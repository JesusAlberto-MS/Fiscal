defmodule Fiscal.Http.MemoryClient do
  @moduledoc """
  Contiene la lógica para peticiones http en memoria.
  Sirve como emulador de respuestas http para pruebas.
  """
  @behaviour Fiscal.Http.Adapter

  def request(method, url, opts) do
    case {method, URI.parse(url).path} do
      {:get, "/ping"} ->
        {:ok,
         %{
           status: 200,
           category: :success,
           body: ~s({"msg":"pong"}),
           headers: [{"content-type", "application/json"}]
         }}

      {:post, "/echo"} ->
        %{json: body} = get_options(opts)
        {:ok, %{status: 201, category: :success, body: ~s({"echo": #{body}})}}

      {:get, "/notfound"} ->
        {:ok, %{status: 404, category: :redirect, body: "Not Found"}}

      {:get, "/fail"} ->
        {:ok, %{status: 500, category: :server_error, body: "Boom"}}

      {:get, "/timeout"} ->
        {:error, RuntimeError.exception("timeout connecting to #{url}")}

      # Endpoints para People
      {:get, "/people/" <> person_id} ->
        get_person(person_id)

      {:post, "/people"} ->
        create_person(opts)

      {:put, "/people/" <> person_id} ->
        update_person(person_id, opts)

      {:delete, "/people/" <> person_id} ->
        delete_person(person_id)

      _ ->
        {:ok, %{status: 418, category: :client_error, body: "I'm a teapot"}}
    end
  end

  # Helpers para People endpoints
  defp get_person("fail-get-id") do
    {:error, :forced_get_failure}
  end

  defp get_person("a918d0d4-8034-48ce-834e-56306b27636a") do
    response = %{
      "data" => %{
        "id" => "a918d0d4-8034-48ce-834e-56306b27636a",
        "legalName" => "JESUS ALBERTO MARTINEZ SANTOS",
        "email" => "jesus1@romikya.mx",
        "curp" => "MASJ020408HPLRNSA0",
        "tin" => "MASJ020408SF7",
        "zipCode" => "73176",
        "satCfdiUseId" => "S01",
        "satTaxRegimeId" => "626",
        "userTypeId" => "C",
        "createdAt" => "2025-11-06T11:34:01.652",
        "updatedAt" => "2025-11-06T11:34:01.663"
      },
      "httpStatusCode" => 200,
      "succeeded" => true
    }

    {:ok, %{status: 200, category: :success, body: Jason.encode!(response)}}
  end

  defp get_person(_person_id) do
    {:ok, %{status: 404, category: :client_error, body: "Not Found"}}
  end

  defp create_person(opts) do
    json_body = Keyword.get(opts, :json, %{})

    case json_body do
      %{"tin" => "FAIL_TIN"} ->
        {:error, :forced_creation_failure}

      %{
        "legalName" => "KARLA FUENTE NOLASCO",
        "tin" => "FUNK671228PH6",
        "email" => "karlafuente1@gmail.com"
      } ->
        response = %{
          "data" => %{
            "id" => "4f9debef-5f22-4827-a73c-7be38e9e5251",
            "legalName" => "KARLA FUENTE NOLASCO",
            "email" => "karlafuente1@gmail.com",
            "tin" => "FUNK671228PH6",
            "zipCode" => "01160",
            "curp" => nil,
            "phoneNumber" => nil,
            "satCfdiUseId" => "S01",
            "satTaxRegimeId" => "626",
            "userTypeId" => "C",
            "tenantId" => "8665b1b3-752b-4128-8114-a2057f3f0e76",
            "createdAt" => "2025-11-06T13:02:17.944",
            "updatedAt" => "2025-11-06T13:02:17.955"
          },
          "httpStatusCode" => 200,
          "succeeded" => true
        }

        {:ok, %{status: 200, category: :success, body: Jason.encode!(response)}}

      _ ->
        {:ok, %{status: 400, category: :client_error, body: "Bad Request"}}
    end
  end

  defp update_person("fail-update-id", _opts) do
    {:error, :forced_update_failure}
  end

  defp update_person("a918d0d4-8034-48ce-834e-56306b27636a", opts) do
    json_body = Keyword.get(opts, :json, %{})

    case json_body do
      %{"email" => "jesus2@romikya.mx", "id" => "a918d0d4-8034-48ce-834e-56306b27636a"} ->
        response = %{
          "data" => %{
            "id" => "a918d0d4-8034-48ce-834e-56306b27636a",
            "legalName" => "JESUS ALBERTO MARTINEZ SANTOS",
            "email" => "jesus2@romikya.mx",
            "tin" => "MASJ020408SF7",
            "zipCode" => "73176",
            "curp" => "MASJ020408HPLRNSA0",
            "satCfdiUseId" => "S01",
            "satTaxRegimeId" => "626",
            "userTypeId" => "C",
            "createdAt" => "2025-11-06T11:34:01.652",
            "updatedAt" => "2025-11-06T13:30:33.552"
          },
          "httpStatusCode" => 200,
          "succeeded" => true
        }

        {:ok, %{status: 200, category: :success, body: Jason.encode!(response)}}

      _ ->
        {:ok, %{status: 400, category: :client_error, body: "Bad Request"}}
    end
  end

  defp update_person(_person_id, _opts) do
    {:ok, %{status: 404, category: :client_error, body: "Not Found"}}
  end

  defp delete_person("fail-delete-id") do
    {:error, :forced_deletion_failure}
  end

  defp delete_person("248ceda1-7a1d-4ee8-8443-2e876fb22e3b") do
    response = %{
      "data" => true,
      "details" => "",
      "httpStatusCode" => 200,
      "message" => "",
      "succeeded" => true
    }

    {:ok, %{status: 200, category: :success, body: Jason.encode!(response)}}
  end

  defp delete_person(_person_id) do
    {:ok, %{status: 404, category: :client_error, body: "Not Found"}}
  end

  def get_options(opts) do
    json =
      opts
      |> Keyword.get(:json)
      |> Jason.encode!()

    %{
      headers: Keyword.get(opts, :headers, []),
      json: json
    }
  end

  def get(url, opts \\ []), do: request(:get, url, opts)
  def post(url, opts \\ []), do: request(:post, url, opts)
  def put(url, opts \\ []), do: request(:put, url, opts)
  def patch(url, opts \\ []), do: request(:patch, url, opts)
  def delete(url, opts \\ []), do: request(:delete, url, opts)
end
