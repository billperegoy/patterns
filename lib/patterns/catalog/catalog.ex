defmodule Patterns.Catalog do
  alias Patterns.{Catalog, Repo}
  alias Catalog.{Price, Product}

  def create_product(attrs) do
    with {:ok, product} <- create_product_without_price(attrs),
         {:ok, _price} <- create_price(Map.put(attrs, :product_id, product.id)) do
      {:ok, Repo.preload(product, :prices)}
    end
  end

  def update_product_price(product, price) do
    with {:ok, _price} <- create_price(%{product_id: product.id, price: price}) do
      {:ok, Repo.preload(product, [:prices], force: true)}
    end
  end

  defp create_product_without_price(attrs) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def create_price(attrs) do
    %Price{}
    |> Price.changeset(attrs)
    |> Repo.insert()
  end
end
