defmodule UrlShortenerExWeb.PageController do
  use UrlShortenerExWeb, :controller
  alias UrlShortenerEx.Cache

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def redirector(conn, %{"short_url" => short_url}) do
    case Base62.decode(short_url) do
      {:ok, short_url_id} ->
        case Cache.lookup(short_url_id) do
          [] ->
            IO.puts("Cache missed for #{short_url}")
            fetch_and_redirect_or_error(conn, short_url_id)

          [{_, original_url}] ->
            IO.puts("Cache hit for #{short_url}")
            redirect_to_url(conn, original_url)
        end

      :error ->
        # Handle the decoding error, e.g., log the error and redirect to a fallback page or show an error message
        IO.puts("Failed to decode short_url: #{short_url}")
        conn
        |> put_flash(:error, "Invalid URL")
        |> redirect(to: "/error_page")
    end
  end

  defp fetch_and_redirect_or_error(conn, short_url_id) do
    case UrlShortenerEx.UrlShortener.get_url_mapping_by_short_url_id!(short_url_id) do
      nil ->
        conn
        |> put_flash(:error, "Short URL not found")
        |> redirect(to: "/")

      %UrlShortenerEx.UrlShortener.UrlMapping{} = url_mapping ->
        # Insert the mapping into the cache for future lookups
        case Cache.insert(short_url_id, url_mapping.original_url) do
          true -> IO.puts("Inserted #{short_url_id} into cache")
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
