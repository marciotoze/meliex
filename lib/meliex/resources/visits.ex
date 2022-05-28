defmodule Meliex.Resources.Visits do
  alias Meliex.Client

  def me(token) do
    Client.get("/users/me", %{}, token: token)
  end

  def today(user_id, token) do
    {:ok, date_from} =
      Timex.now()
      |> Timex.beginning_of_day()
      |> Timex.format("{ISO:Extended}")

    {:ok, date_to} =
      Timex.now()
      |> Timex.end_of_day()
      |> Timex.format("{ISO:Extended}")

    range(user_id, date_from, date_to, token)
  end

  def range(user_id, date_from, date_to, token) do
    Client.get(
      "/users/#{user_id}/items_visits",
      %{date_from: date_from, date_to: date_to},
      token: token
    )
  end

  def items_today(items_ids, token) do
    {:ok, date_from} =
      Timex.now()
      |> Timex.beginning_of_day()
      |> Timex.format("{ISO:Extended}")

    {:ok, date_to} =
      Timex.now()
      |> Timex.end_of_day()
      |> Timex.format("{ISO:Extended}")

    items_range(items_ids, date_from, date_to, token)
  end

  def items_yesterday(items_ids, token) do
    {:ok, date_from} =
      Timex.now()
      |> Timex.shift(days: -1)
      |> Timex.beginning_of_day()
      |> Timex.format("{ISO:Extended}")

    {:ok, date_to} =
      Timex.now()
      |> Timex.shift(days: -1)
      |> Timex.end_of_day()
      |> Timex.format("{ISO:Extended}")

    items_range(items_ids, date_from, date_to, token)
  end

  def items_range(items_ids, date_from, date_to, token) do
    Client.get(
      "/items/visits",
      %{ids: items_ids, date_from: date_from, date_to: date_to},
      token: token
    )
  end
end
