defmodule Meliex.Resources.User do
  alias Meliex.Client

  @spec me(Client.credential()) :: {:ok, Tesla.Env.t()} | {:error, any()}
  def me(credential) do
    Client.get(credential, "/users/me")
  end

  @spec find(Client.credential(), integer) :: {:ok, Tesla.Env.t()} | {:error, any()}
  def find(credential, user_id) do
    Client.get(credential, "/users/#{user_id}")
  end
end
