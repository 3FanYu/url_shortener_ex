defmodule UrlShortenerExWeb.PageController do
  use UrlShortenerExWeb, :controller
  alias UrlShortenerEx.Cache

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def redirector(conn, %{"short_url" => short_url}) do
    case Cache.lookup(short_url) do
      [] ->
        IO.puts("Cache missed for #{short_url}")
        fetch_and_redirect_or_error(conn, short_url)

      [{_,original_url}] ->
        IO.puts("Cache hit for #{short_url}")
        redirect_to_url(conn, original_url)
    end
  end

  defp fetch_and_redirect_or_error(conn, short_url) do
    case UrlShortenerEx.UrlShortener.get_url_mapping_by_short_url!(short_url) do
      nil ->
        conn
        |> put_flash(:error, "Short URL not found")
        |> redirect(to: "/")

      %UrlShortenerEx.UrlShortener.UrlMapping{} = url_mapping ->
        # Insert the mapping into the cache for future lookups
        case Cache.insert(short_url, url_mapping.original_url) do
          true -> IO.puts("Inserted #{short_url} into cache")
        end
        redirect_to_url(conn, url_mapping.original_url)
    end
  end

  defp redirect_to_url(conn, url) do
    conn
    |> put_resp_header("location", url)
    |> send_resp(302, "")
  end
end
