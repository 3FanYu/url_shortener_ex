defmodule UrlShortenerEx.Repo do
  use Ecto.Repo,
    otp_app: :url_shortener_ex,
    adapter: Ecto.Adapters.Postgres
end
