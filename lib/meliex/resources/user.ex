defmodule Meliex.Resources.User do
  alias Meliex.Client

  def me(token) do
    Client.get("/users/me", %{}, token: token)
  end

  def find(user_id, token) do
    Client.get("/users/#{user_id}", %{}, token: token)
  end
end
