defmodule Patterns.Revisable do
  alias Patterns.Repo
  alias Ecto.Multi

  defmacro derive_revisable(name, options) do
    quote do
      def unquote(:"create_#{name}")(attrs) do
        %{type: parent_type, changeset: parent_changeset} = Keyword.get(unquote(options), :parent)

        %{type: revision_type, changeset: revision_changeset} =
          Keyword.get(unquote(options), :revision)

        with {:ok, %{parent: parent}} <-
               Multi.new()
               |> Multi.insert(:parent, parent_changeset.(parent_type, attrs))
               |> Multi.insert(:revision, fn %{parent: parent} ->
                 revision_changeset.(revision_type, Map.put(attrs, :product_id, parent.id))
               end)
               |> Repo.transaction() do
          # FIXME - use a generic name here
          {:ok, Repo.preload(parent, :prices)}
        end
      end
    end
  end
end
