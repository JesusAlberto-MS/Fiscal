defmodule Fiscal.Payloads.PersonTest do
  use ExUnit.Case
  doctest Fiscal.Payloads.Person
  alias Fiscal.Payloads.Person

  @valid_json ~S({
    "legalName": "Nombre o Razón Social de Ejemplo",
    "tin": "RFC123",
    "email": "ejemplo@correo.com",
    "satTaxRegimeId": "601",
    "satCfdiUseId": "G03",
    "zipCode": "12345",
    "password": "ContraseniaSegura123."
  })

  describe "parse/1" do
    test "cuando el json es válido" do
      {:ok, person} = Person.parse(@valid_json)

      # al ser un esquema embebido de ecto, se tiene un id
      # que se puede usar si es deseado o bien, omitir
      assert %Person{
               email: "ejemplo@correo.com",
               id: nil,
               legal_name: "Nombre o Razón Social de Ejemplo",
               password: "ContraseniaSegura123.",
               sat_cfdi_use_id: "G03",
               sat_tax_regime_id: "601",
               tin: "RFC123",
               zip_code: "12345"
             } = person
    end

    test "cuando el json tiene los atributos requeridos" do
      valid_json = ~S({
        "legalName": "Nombre o Razón Social de Ejemplo",
        "email": "ejemplo@correo.com",
        "password": "ContraseniaSegura123."
       })
      {:ok, person} = Person.parse(valid_json)

      assert %Person{
               email: "ejemplo@correo.com",
               legal_name: "Nombre o Razón Social de Ejemplo",
               password: "ContraseniaSegura123."
             } = person
    end

    test "cuando el json no tiene atributos requeridos" do
      valid_json = ~S({
        "email": "ejemplo@correo.com",
        "password": "ContraseniaSegura123."
          })
      {:error, changeset} = Person.parse(valid_json)
      assert [legal_name: {"can't be blank", [validation: :required]}] = changeset.errors
    end
  end
end
