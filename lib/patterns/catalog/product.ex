defmodule Patterns.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Patterns.Catalog.Price

  schema "products" do
    field :name, :string

    has_many :prices, Price
    timestamps type: :utc_datetime_usec
  end

  def changeset(%__MODULE__{} = product, attrs) do
    required_attrs = [:name]

    product
    |> cast(attrs, required_attrs)
    |> validate_required(required_attrs)
    |> unique_constraint(:name)
  end
end
