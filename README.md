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





