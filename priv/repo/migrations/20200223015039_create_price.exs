defmodule Patterns.Repo.Migrations.CreatePrice do
  use Ecto.Migration

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
end
