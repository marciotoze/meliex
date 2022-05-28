defmodule Meliex.Resources.Item do
  alias Meliex.Client

  def find(ids, token) when is_list(ids), do: find(Enum.join(ids, ","), token)

  def find(ids, token) when is_binary(ids) do
    Client.get("/items", %{ids: ids}, token: token)
  end

  def list_by_user(user_id, params \\ %{}, token) do
    Client.get("/users/#{user_id}/items/search", params, token: token)
  end

  def scan(user_id, params \\ %{}, token) do
    params =
      Map.merge(
        %{
          search_type: "scan",
          limit: 100
        },
        params
      )

    Client.get("/users/#{user_id}/items/search", params, token: token)
  end

  def all_by_user(user_id, token) do
    {:ok, %{body: %{"results" => results, "scroll_id" => scroll_id}}} = scan(user_id, %{}, token)

    item_ids =
      Stream.iterate(%{results: results, scroll_id: scroll_id}, fn %{scroll_id: scroll_id} ->
        {:ok, %{body: %{"results" => current_results, "scroll_id" => scroll_id}}} =
          scan(user_id, %{scroll_id: scroll_id}, token)

        %{
          results: current_results,
          scroll_id: scroll_id
        }
      end)
      |> Enum.take_while(fn %{results: results} ->
        results != []
      end)
      |> Enum.reduce([], fn %{results: results}, acc ->
        acc ++ results
      end)

    {:ok, item_ids}
  end
end
