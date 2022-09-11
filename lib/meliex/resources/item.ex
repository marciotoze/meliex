defmodule Meliex.Resources.Item do
  alias Meliex.Client

  @limit 50

  def find(credential, ids) when is_list(ids), do: find(credential, Enum.join(ids, ","))

  def find(credential, ids) when is_binary(ids) do
    Client.get(credential, "/items", %{ids: ids})
  end

  def list_by_user(credential, user_id, params \\ %{}) do
    Client.get(credential, "/users/#{user_id}/items/search", params)
  end

  def all_by_user(credential, nickname) do
    %{total: total, results: results} = get_user_products_by_page(credential, nickname, 0)

    total_pages = ceil(total / @limit)

    tasks =
      Enum.map(1..total_pages, fn n ->
        Task.async(fn -> get_user_products_by_page(credential, nickname, n) end)
      end)

    other_results =
      tasks
      |> Task.await_many()
      |> Enum.flat_map(& &1[:results])

    results ++ other_results
  end

  def get_user_products_by_page(credential, nickname, page) do
    params = %{offset: page * @limit, limit: @limit}

    {:ok, %{body: body}} =
      Client.get(
        credential,
        "https://api.mercadolibre.com/sites/MLB/search?nickname=#{nickname}",
        params
      )

    %{
      total: body["paging"]["total"],
      results: Enum.map(body["results"], & &1["id"])
    }
  end
end
