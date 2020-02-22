defmodule Patterns.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :price, :float

      timestamps type: :utc_datetime_usec
    end
  end
end
