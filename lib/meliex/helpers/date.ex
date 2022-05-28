defmodule Meliex.Helpers.DateHelper do
  def now do
    DateTime.utc_now()
    |> DateTime.truncate(:millisecond)
    |> DateTime.to_iso8601()
  end

  def today do
  end
end
