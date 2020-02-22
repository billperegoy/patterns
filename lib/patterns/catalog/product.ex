defmodule Patterns.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :price, :float

    timestamps type: :utc_datetime_usec
  end

  def changeset(%__MODULE__{} = product, attrs) do
    required_attrs = [:name, :price]

    product
    |> cast(attrs, required_attrs)
    |> validate_required(required_attrs)
    |> unique_constraint(:name)
  end
end
