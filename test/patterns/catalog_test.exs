defmodule Patterns.Test.CatalogTest do
  use Patterns.DataCase

  alias Patterns.Catalog

  test "create product with price" do
    {:ok, product} = Catalog.create_product(%{name: "product", price: 9.99})

    assert product.name == "product"
    [current_price] = product.prices
    assert current_price.price == 9.99
  end
end
