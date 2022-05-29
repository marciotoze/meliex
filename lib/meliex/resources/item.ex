defmodule Meliex.Resources.Item do
  alias Meliex.Client

  @limit 50

  def find(ids, token) when is_list(ids), do: find(Enum.join(ids, ","), token)

  def find(ids, token) when is_binary(ids) do
    Client.get("/items", %{ids: ids}, token: token)
  end

  def list_by_user(user_id, params \\ %{}, token) do
    Client.get("/users/#{user_id}/items/search", params, token: token)
  end

  def all_by_user(user_id, token) do
    tasks =
      Enum.map(0..9, fn n ->
        Task.async(fn -> get_user_products_by_page(user_id, n, token) end)
      end)

    tasks
    |> Task.await_many()
    |> List.flatten()
  end

  def get_user_products_by_page(user_id, page, token) do
    params = %{offset: page * @limit, limit: @limit}

    {:ok, %{body: %{"results" => results}}} =
      Client.get(
        "https://api.mercadolibre.com/sites/MLB/search?seller_id=#{user_id}",
        params,
        token: token
      )

    Enum.map(results, & &1["id"])
  end
end
