defmodule Fiscal.Http.MemoryClient do
  @moduledoc """
  Contiene la lógica para peticiones http en memoria.
  Sirve como emulador de respuestas http para pruebas.
  """

  @behaviour Fiscal.Http.Client

  @impl true
  def new(_opts \\ []) do
    Req.new()
  end

  @impl true
  def get(client, path, opts \\ [])

  def get(_client, "/people/a918d0d4-8034-48ce-834e-56306b27636a", _opts) do
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

    {:ok, response}
  end

  def get(_client, "/people", _opts) do
    response = %{
      "data" => %{
        "hasNextPage" => false,
        "hasPreviousPage" => false,
        "items" => [
          %{
            "createdAt" => "2025-11-06T11:34:01.652",
            "curp" => "MASJ020408HPLRNSA0",
            "email" => "jesus2@romikya.mx",
            "id" => "a918d0d4-8034-48ce-834e-56306b27636a",
            "legalName" => "JESUS ALBERTO MARTINEZ SANTOS",
            "satCfdiUse" => %{
              "description" => "Sin efectos fiscales.  ",
              "id" => "S01"
            },
            "satTaxRegime" => %{
              "description" => "Régimen Simplificado de Confianza",
              "id" => "626"
            },
            "tin" => "MASJ020408SF7",
            "updatedAt" => "2025-11-06T13:30:33.552",
            "userType" => %{
              "description" => "Cliente",
              "id" => "C"
            },
            "zipCode" => "73176"
          },
          %{
            "createdAt" => "2025-11-06T13:02:17.944",
            "curp" => nil,
            "email" => "karlafuente1@gmail.com",
            "id" => "4f9debef-5f22-4827-a73c-7be38e9e5251",
            "legalName" => "KARLA FUENTE NOLASCO",
            "satCfdiUse" => %{
              "description" => "Sin efectos fiscales.  ",
              "id" => "S01"
            },
            "satTaxRegime" => %{
              "description" => "Régimen Simplificado de Confianza",
              "id" => "626"
            },
            "tin" => "FUNK671228PH6",
            "updatedAt" => "2025-11-06T13:02:17.955",
            "userType" => %{
              "description" => "Cliente",
              "id" => "C"
            },
            "zipCode" => "01160"
          }
        ],
        "pageNumber" => 1,
        "totalCount" => 2,
        "totalPages" => 1
      },
      "httpStatusCode" => 200,
      "succeeded" => true
    }

    {:ok, response}
  end

  @impl true
  def post(client, path, body, opts \\ [])

  def post(
        _client,
        "/people",
        %{
          "legalName" => "KARLA FUENTE NOLASCO",
          "tin" => "FUNK671228PH6",
          "email" => "karlafuente1@gmail.com",
          "satTaxRegimeId" => "626",
          "satCfdiUseId" => "S01",
          "zipCode" => "01160",
          "password" => "UserPass123456789."
        },
        _opts
      ) do
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

    {:ok, response}
  end

  @impl true
  def put(client, path, body, opts \\ [])

  def put(
        _client,
        "/people/a918d0d4-8034-48ce-834e-56306b27636a",
        %{
          "email" => "jesus2@romikya.mx",
          "id" => "a918d0d4-8034-48ce-834e-56306b27636a"
        },
        _opts
      ) do
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

    {:ok, response}
  end

  @impl true
  def delete(client, path, opts \\ [])

  def delete(_client, "/people/248ceda1-7a1d-4ee8-8443-2e876fb22e3b", _opts) do
    response = %{
      "data" => true,
      "details" => "",
      "httpStatusCode" => 200,
      "message" => "",
      "succeeded" => true
    }

    {:ok, response}
  end
end
