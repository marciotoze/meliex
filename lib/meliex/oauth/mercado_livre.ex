defmodule Meliex.OAuth.MercadoLivre do
  use OAuth2.Strategy

  defstruct [:access_token, :refresh_token, :expires_at]

  def client(refresh_token \\ nil) do
    OAuth2.Client.new(
      strategy: __MODULE__,
      client_id: "3959417591971484",
      client_secret: "1GhBt7gnHrtOPUbyHANiZbKobQrxubUm",
      redirect_uri: "https://localhost:4000/auth/callback",
      site: "https://api.mercadolibre.com",
      authorize_url: "https://auth.mercadolivre.com.br/authorization",
      token: %OAuth2.AccessToken{refresh_token: refresh_token},
      params: %{
        client_id: "3959417591971484",
        client_secret: "1GhBt7gnHrtOPUbyHANiZbKobQrxubUm"
      },
      token_url: "https://api.mercadolibre.com/oauth/token"
    )
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  def authorize_url! do
    OAuth2.Client.authorize_url!(client(), scope: "user,public_repo")
  end

  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(client(), params, headers, opts)
  end

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end

  def refresh_token!(refresh_token, params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.refresh_token!(client(refresh_token), params, headers, opts)
  end
end
