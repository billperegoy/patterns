defmodule PatternsWeb.PageController do
  use PatternsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
