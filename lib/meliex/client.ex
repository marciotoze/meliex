defmodule Meliex.Client do
  @base_url "https://api.mercadolibre.com"

  @spec get(String.t(), map()) :: {:ok, map()} | {:error, map()}
  def get(path, params \\ %{}, opts \\ []) do
    opts
    |> create()
    |> Tesla.get(path, query: map_to_klist(params))
  end

  @spec post(String.t(), map()) :: {:ok, map()} | {:error, map()}
  def post(path, params \\ %{}, opts \\ []) do
    opts
    |> create()
    |> Tesla.post(path, params)
  end

  @spec patch(String.t(), map()) :: {:ok, map()} | {:error, map()}
  def patch(path, params \\ %{}, opts \\ []) do
    opts
    |> create()
    |> Tesla.patch(path, params)
  end

  @spec put(String.t(), map()) :: {:ok, map()} | {:error, map()}
  def put(path, params \\ %{}, opts \\ []) do
    opts
    |> create()
    |> Tesla.put(path, params)
  end

  @spec delete(String.t()) :: {:ok, map()} | {:error, map()}
  def delete(path, opts \\ []) do
    opts
    |> create()
    |> Tesla.delete(path)
  end

  defp map_to_klist(dict) do
    Enum.map(dict, fn {key, value} -> {to_atom(key), value} end)
  end

  defp to_atom(atom) when is_atom(atom), do: atom
  defp to_atom(string), do: String.to_atom(string)

  defp create(opts) do
    additional_headers = Keyword.get(opts, :additional_headers, [])
    headers = auth_headers(opts[:token]) ++ additional_headers

    middleware = [
      {Tesla.Middleware.BaseUrl, @base_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, headers}
    ]

    adapter = {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}

    Tesla.client(middleware, adapter)
  end

  defp auth_headers(nil), do: []
  defp auth_headers(token), do: [{"Authorization", "Bearer #{token}"}]
end
