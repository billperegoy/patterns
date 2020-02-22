defmodule Patterns.Catalog do
  alias Patterns.{Catalog.Product, Repo}

  def create_product(attrs) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end
end
