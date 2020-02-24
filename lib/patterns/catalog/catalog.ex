defmodule Patterns.Catalog do
  alias Patterns.Catalog
  alias Catalog.{Price, Product}

  import Patterns.Revisable

  derive_revisable("product",
    parent: %{type: %Product{}, changeset: &Product.changeset/2},
    revision: %{type: %Price{}, changeset: &Price.changeset/2}
  )
end
