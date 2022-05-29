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

  def all_by_user(nickname, token) do
    %{total: total, results: results} = get_user_products_by_page(nickname, 0, token)

    total_pages = ceil(total / @limit)

    tasks =
      Enum.map(1..total_pages, fn n ->
        Task.async(fn -> get_user_products_by_page(nickname, n, token) end)
      end)

    other_results =
      tasks
      |> Task.await_many()
      |> Enum.flat_map(& &1[:results])

    results ++ other_results
  end

  def get_user_products_by_page(nickname, page, token) do
    params = %{offset: page * @limit, limit: @limit}

    {:ok, %{body: body}} =
      Client.get(
        "https://api.mercadolibre.com/sites/MLB/search?nickname=#{nickname}",
        params,
        token: token
      )

    %{
      total: body["paging"]["total"],
      results: Enum.map(body["results"], & &1["id"])
    }
  end
end
