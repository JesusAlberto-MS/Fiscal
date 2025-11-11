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
      response = Jason.decode!(response)
      assert response["httpStatusCode"] == 200
      assert response["succeeded"] == true

      data = response["data"]
      assert data["id"] == "4f9debef-5f22-4827-a73c-7be38e9e5251"
      assert data["legalName"] == "KARLA FUENTE NOLASCO"
      assert data["email"] == "karlafuente1@gmail.com"
      assert data["tin"] == "FUNK671228PH6"
      assert data["zipCode"] == "01160"
      assert data["satCfdiUseId"] == "S01"
      assert data["satTaxRegimeId"] == "626"
      assert data["userTypeId"] == "C"
    end

    test "crea una persona con atributos en formato string" do
      attrs = %{
        "legal_name" => "KARLA FUENTE NOLASCO",
        "tin" => "FUNK671228PH6",
        "email" => "karlafuente1@gmail.com",
        "sat_tax_regime_id" => "626",
        "sat_cfdi_use_id" => "S01",
        "zip_code" => "01160",
        "password" => "UserPass123456789."
      }

      assert {:ok, response} = People.create(attrs)
      response = Jason.decode!(response)
      assert response["httpStatusCode"] == 200
      assert response["succeeded"] == true
    end

    test "devuelve un error si la creación de la persona falla" do
      attrs = %{
        legal_name: "FAILING PERSON",
        tin: "FAIL_TIN",
        email: "fail@fail.com",
        sat_tax_regime_id: "616",
        sat_cfdi_use_id: "G03",
        zip_code: "00000",
        password: "UserPass123456789."
      }

      assert {:error, :forced_creation_failure} = People.create(attrs)
    end
  end

  describe "get/1" do
    test "obtiene una persona por su ID" do
      person_id = "a918d0d4-8034-48ce-834e-56306b27636a"

      assert {:ok, response} = People.get(person_id)
      response = Jason.decode!(response)
      assert response["httpStatusCode"] == 200
      assert response["succeeded"] == true

      data = response["data"]
      assert data["id"] == person_id
      assert data["legalName"] == "JESUS ALBERTO MARTINEZ SANTOS"
      assert data["email"] == "jesus1@romikya.mx"
      assert data["tin"] == "MASJ020408SF7"
      assert data["curp"] == "MASJ020408HPLRNSA0"
      assert data["zipCode"] == "73176"
      assert data["satCfdiUseId"] == "S01"
      assert data["satTaxRegimeId"] == "626"
    end

    test "verifica que los campos de timestamp estén presentes" do
      person_id = "a918d0d4-8034-48ce-834e-56306b27636a"

      assert {:ok, response} = People.get(person_id)
      response = Jason.decode!(response)
      data = response["data"]

      assert data["createdAt"] == "2025-11-06T11:34:01.652"
      assert data["updatedAt"] == "2025-11-06T11:34:01.663"
    end

    test "devuelve un error si la obtención de la persona falla" do
      person_id = "fail-get-id"

      assert {:error, :forced_get_failure} = People.get(person_id)
    end
  end

  describe "update/2" do
    test "actualiza el email de una persona" do
      person_id = "a918d0d4-8034-48ce-834e-56306b27636a"
      attrs = %{email: "jesus2@romikya.mx"}

      assert {:ok, response} = People.update(person_id, attrs)
      response = Jason.decode!(response)
      assert response["httpStatusCode"] == 200
      assert response["succeeded"] == true

      data = response["data"]
      assert data["id"] == person_id
      assert data["email"] == "jesus2@romikya.mx"
      assert data["updatedAt"] == "2025-11-06T13:30:33.552"
    end

    test "actualiza múltiples campos de una persona" do
      person_id = "a918d0d4-8034-48ce-834e-56306b27636a"

      attrs = %{
        email: "jesus2@romikya.mx"
      }

      assert {:ok, response} = People.update(person_id, attrs)
      response = Jason.decode!(response)

      data = response["data"]
      assert data["email"] == "jesus2@romikya.mx"
      # Verifica que otros campos se mantuvieron
      assert data["legalName"] == "JESUS ALBERTO MARTINEZ SANTOS"
      assert data["tin"] == "MASJ020408SF7"
    end

    test "actualiza con atributos en formato string" do
      person_id = "a918d0d4-8034-48ce-834e-56306b27636a"
      attrs = %{"email" => "jesus2@romikya.mx"}

      assert {:ok, response} = People.update(person_id, attrs)
      response = Jason.decode!(response)
      assert response["httpStatusCode"] == 200

      data = response["data"]
      assert data["email"] == "jesus2@romikya.mx"
    end

    test "devuelve un error si la actualización de la persona falla" do
      person_id = "fail-update-id"
      attrs = %{email: "new@email.com"}

      assert {:error, :forced_update_failure} = People.update(person_id, attrs)
    end
  end

  describe "delete/1" do
    test "elimina una persona por su ID" do
      person_id = "248ceda1-7a1d-4ee8-8443-2e876fb22e3b"

      assert {:ok, response} = People.delete(person_id)
      response = Jason.decode!(response)
      assert response["httpStatusCode"] == 200
      assert response["succeeded"] == true
      assert response["data"] == true
    end

    test "verifica la estructura completa de respuesta al eliminar" do
      person_id = "248ceda1-7a1d-4ee8-8443-2e876fb22e3b"

      assert {:ok, response} = People.delete(person_id)
      response = Jason.decode!(response)

      assert Map.has_key?(response, "data")
      assert Map.has_key?(response, "details")
      assert Map.has_key?(response, "httpStatusCode")
      assert Map.has_key?(response, "message")
      assert Map.has_key?(response, "succeeded")

      assert response["details"] == ""
      assert response["message"] == ""
    end

    test "devuelve un error si la eliminación de la persona falla" do
      person_id = "fail-delete-id"

      assert {:error, :forced_deletion_failure} = People.delete(person_id)
    end
  end
end
