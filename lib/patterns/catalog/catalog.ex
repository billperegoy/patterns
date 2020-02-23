defmodule Patterns.Catalog do
  alias Patterns.{Catalog, Repo}
  alias Catalog.{Price, Product}
  alias Ecto.Multi

  def create_product(attrs) do
    with {:ok, %{product: product}} <-
           Multi.new()
           |> Multi.insert(:product, Product.changeset(%Product{}, attrs))
           |> Multi.insert(:price, fn %{product: product} ->
             Price.changeset(%Price{}, Map.put(attrs, :product_id, product.id))
           end)
           |> Repo.transaction() do
      {:ok, Repo.preload(product, :prices)}
    end
  end
end
