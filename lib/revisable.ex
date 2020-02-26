defmodule Patterns.Revisable do
  alias Patterns.Repo
  alias Ecto.Multi

  defmacro derive_revisable(name, options) do
    quote do
      def unquote(:"create_#{name}")(attrs) do
        revision_type = Keyword.get(unquote(options), :type)
        %{type: parent_type, changeset: parent_changeset} = Keyword.get(unquote(options), :parent)

        %{type: revision_type, changeset: revision_changeset} =
          Keyword.get(unquote(options), :revision)

        with {:ok, %{parent: parent}} <-
               Multi.new()
               |> Multi.insert(:parent, parent_changeset.(parent_type, attrs))
               |> Multi.insert(:revision, fn %{parent: parent} ->
                 parent_id_atom = String.to_atom("#{unquote(name)}_id")
                 revision_changeset.(revision_type, Map.put(attrs, parent_id_atom, parent.id))
               end)
               |> Repo.transaction() do
          # FIXME - Can we use a generic name (:revisions)
          {:ok, Repo.preload(parent, :prices)}
        end
      end
    end
  end
end
