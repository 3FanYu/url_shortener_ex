defmodule UrlShortenerExWeb.PageController do
  use UrlShortenerExWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def redirector(conn, %{"short_url" => short_url}) do
    case UrlShortenerEx.UrlShortener.get_url_mapping_by_short_url!(short_url) do
      nil ->
        conn
        |> put_flash(:error, "Short URL not found")
        |> redirect(to: "/")

      %UrlShortenerEx.UrlShortener.UrlMapping{} = url_mapping ->
        conn
        |> put_resp_header("location", url_mapping.original_url)
        |> redirect(external: url_mapping.original_url)
    end

  end
end
