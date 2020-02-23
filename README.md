# Patterns

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Overview

### The Simplest Case
In our business we deal a lot with products. In the simplest case, we have a
product that has a price. We could represent that with a simple migration and
schema like this.

```
def change do
  create table(:products) do
    add :name, :string
    add :price, :float

    timestamps type: :utc_datetime_usec
  end
end
```

```
schema "products" do
  field :name, :string
  field :price, :float

  timestamps type: :utc_datetime_usec
end
```

This is just what we need at the start so we build some CRUD functionality. We
build up a changeset and a simple `create_product` function that looks like
this.

```
def create_product(attrs) do
  %Product{}
  |> Product.changeset(attrs)
  |> Repo.insert()
```

### Supporting Price Changes
This is works great but then we realize something. Prices change but we want to
ensure that if a price changes, we'll be able to still have old invoices that
have the old price, along with new orders that use a newer price. So, a product
needs to support multiple prices. This isn't too bad. We simply need a product
that can support one or more prices.

So we need a migration that creates a new entity called `Price`. We then remove
the price value from `Product` and replace it with a reference to the
associated prices.

```
def change do
  create table(:prices) do
    add :price, :float
    add :product_id, references(:products)

    timestamps type: :utc_datetime_usec
  end

  alter table(:products) do
    remove :price, :float
  end
end
```

We then build a schema for price like this:

```
schema "prices" do
  field :price, :float

  belongs_to :product, Product

  timestamps type: :utc_datetime_usec
end
```

We add a function to insert a price and associate it with a product:

```
def create_price(attrs) do
  %Price{}
  |> Price.changeset(attrs)
  |> Repo.insert()
end
```

Since we always want to create a product with a price, we make the original
`create_product/1` function private.

We create this new function:

```
def create_product_and_price(attrs) do
  with {:ok, product} <- create_product(attrs),
       {:ok, _price} <- create_price(Map.put(attrs, :product_id, product.id)) do
    {:ok, Repo.preload(product, :prices)}
  end
end
```

This all works when the world is stable and we always get good data. But what
happens if we try to create a product and price but leave the price out of the
attributes? `create_product/1` succeeds, but we get a validation error on
`create_price/1`. This means we now have a product with no price. Our system
happens to depend upon having a price on every product so this causes lots of
system issues.

Similar issues can occur if the application crashes in the midst of creating a
product or price or if we have a database glitch.

So how can we ensure that we never have this situation occur? Or how can we
recover if we do have this issue?






