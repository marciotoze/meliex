defmodule Meliex.Client do
  @base_url "https://api.mercadolibre.com"

  @type credential :: %{
          access_token: :string,
          refresh_token: :string,
          expires_at: :integer
        }

  alias Meliex.OAuth.MercadoLivre

  @spec get(credential, String.t(), map) :: {:ok, Tesla.Env.t()} | {:error, any()}
  @spec get(atom | %{:expires_at => number, optional(any) => any}, binary, any) ::
          {:error, any} | {:ok, Tesla.Env.t()}
  def get(credential, path, params \\ %{}) do
    Tesla.get(new(credential), path, query: map_to_klist(params))
  end

  @spec post(credential, String.t(), map) :: {:ok, Tesla.Env.t()} | {:error, any()}
  def post(credential, path, params \\ %{}) do
    Tesla.post(new(credential), path, params)
  end

  @spec patch(credential, String.t(), map) :: {:ok, Tesla.Env.t()} | {:error, any()}
  def patch(credential, path, params \\ %{}) do
    Tesla.patch(new(credential), path, params)
  end

  @spec put(credential, String.t(), map) :: {:ok, Tesla.Env.t()} | {:error, any()}
  def put(credential, path, params \\ %{}) do
    Tesla.put(new(credential), path, params)
  end

  @spec delete(credential, String.t()) :: {:ok, Tesla.Env.t()} | {:error, any()}
  def delete(credential, path) do
    Tesla.delete(new(credential), path)
  end

  defp map_to_klist(dict) do
    Enum.map(dict, fn {key, value} -> {to_atom(key), value} end)
  end

  defp to_atom(atom) when is_atom(atom), do: atom
  defp to_atom(string), do: String.to_atom(string)

  defp new(token) do
    token = validate_token(token)

    headers = auth_headers(token.access_token)

    middleware = [
      {Tesla.Middleware.BaseUrl, @base_url},
      Tesla.Middleware.JSON,
      Tesla.Middleware.Logger,
      {Tesla.Middleware.Headers, headers}
    ]

    adapter = {Tesla.Adapter.Hackney, [recv_timeout: 30_000]}

    Tesla.client(middleware, adapter)
  end

  defp validate_token(token) do
    if token.expires_at * 1000 <= :os.system_time(:millisecond) do
      %{token: token} = MercadoLivre.refresh_token!(token.refresh_token)

      Map.take(token, [:access_token, :refresh_token, :expires_at])
    else
      token
    end
  end

  defp auth_headers(nil), do: []
  defp auth_headers(token), do: [{"Authorization", "Bearer #{token}"}]
end
