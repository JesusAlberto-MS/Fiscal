defmodule Fiscal.PeopleTest do
  use ExUnit.Case, async: true

  alias Fiscal.People

  describe "create/1" do
    test "crea una persona con atributos válidos" do
      attrs = %{
        legal_name: "KARLA FUENTE NOLASCO",
        tin: "FUNK671228PH6",
        email: "karlafuente1@gmail.com",
        sat_tax_regime_id: "626",
        sat_cfdi_use_id: "S01",
        zip_code: "01160",
        password: "UserPass123456789."
      }

      assert {:ok, response} = People.create(attrs)
      assert response["httpStatusCode"] == 200
      assert response["succeeded"] == true

      data = response["data"]
      assert data["id"] == "4f9debef-5f22-4827-a73c-7be38e9e5251"
      assert data["legalName"] == "KARLA FUENTE NOLASCO"
      assert data["email"] == "karlafuente1@gmail.com"
      assert data["tin"] == "FUNK671228PH6"
    end
  end

  describe "get/1" do
    test "obtiene una persona por su ID" do
      person_id = "a918d0d4-8034-48ce-834e-56306b27636a"

      assert {:ok, response} = People.get(person_id)
      assert response["httpStatusCode"] == 200

      data = response["data"]
      assert data["id"] == person_id
      assert data["legalName"] == "JESUS ALBERTO MARTINEZ SANTOS"
      assert data["email"] == "jesus1@romikya.mx"
    end
  end

  describe "list/1" do
    test "obtiene una lista de personas" do
      assert {:ok, response} = People.list()
      assert response["httpStatusCode"] == 200

      data = response["data"]
      assert data["totalCount"] == 2
      assert length(data["items"]) == 2

      items = data["items"]
      # Verifica que la primera persona sea la correcta
      assert Enum.at(items, 0)["id"] == "a918d0d4-8034-48ce-834e-56306b27636a"
      # Verifica que la segunda persona sea la correcta
      assert Enum.at(items, 1)["id"] == "4f9debef-5f22-4827-a73c-7be38e9e5251"
    end
  end

  describe "update/2" do
    test "actualiza el email de una persona" do
      person_id = "a918d0d4-8034-48ce-834e-56306b27636a"
      attrs = %{email: "jesus2@romikya.mx"}

      assert {:ok, response} = People.update(person_id, attrs)
      assert response["httpStatusCode"] == 200

      data = response["data"]
      assert data["id"] == person_id
      # Verifica que el campo actualizado es el correcto
      assert data["email"] == "jesus2@romikya.mx"
      # Verifica que el timestamp de actualización se ha establecido
      assert data["updatedAt"] == "2025-11-06T13:30:33.552"
    end
  end

  describe "delete/1" do
    test "elimina una persona por su ID" do
      person_id = "248ceda1-7a1d-4ee8-8443-2e876fb22e3b"

      assert {:ok, response} = People.delete(person_id)
      assert response["httpStatusCode"] == 200
      # El MemoryClient devuelve `true` en "data" para una eliminación exitosa
      assert response["data"] == true
    end
  end
end
