defmodule Patterns.Catalog.Price do
  use Ecto.Schema
  import Ecto.Changeset

  alias Patterns.Catalog.Product

  schema "prices" do
    field :price, :float

    belongs_to :product, Product

    timestamps type: :utc_datetime_usec
  end

  def changeset(%__MODULE__{} = price, attrs) do
    required_attrs = [:price, :product_id]

    price
    |> cast(attrs, required_attrs)
    |> validate_required(required_attrs)
  end
end
