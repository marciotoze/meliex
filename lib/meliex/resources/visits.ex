defmodule Meliex.Resources.Visits do
  alias Meliex.Client

  def today(credential, user_id) do
    range(credential, user_id, beginning_of_day_plus(), end_of_day_plus())
  end

  def range(credential, user_id, date_from, date_to) do
    Client.get(
      credential,
      "/users/#{user_id}/items_visits",
      %{date_from: date_from, date_to: date_to}
    )
  end

  def items_today(credential, items_ids) do
    items_range(credential, items_ids, beginning_of_day_plus(), end_of_day_plus())
  end

  def items_yesterday(credential, items_ids) do
    items_range(credential, items_ids, beginning_of_day_plus(-1), end_of_day_plus(-1))
  end

  def items_range(credential, items_ids, date_from, date_to) do
    Client.get(
      credential,
      "/items/visits",
      %{ids: items_ids, date_from: date_from, date_to: date_to}
    )
  end

  defp end_of_day_plus(days \\ 0) do
    {:ok, date} =
      Timex.now()
      |> Timex.shift(days: days)
      |> Timex.end_of_day()
      |> Timex.format("{ISO:Extended}")

    date
  end

  defp beginning_of_day_plus(days \\ 0) do
    {:ok, date} =
      Timex.now()
      |> Timex.shift(days: days)
      |> Timex.beginning_of_day()
      |> Timex.format("{ISO:Extended}")

    date
  end
end
