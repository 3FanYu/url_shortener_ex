defmodule UrlShortenerExWeb.UrlMappingController do
  use UrlShortenerExWeb, :controller

  alias UrlShortenerEx.UrlShortener
  alias UrlShortenerEx.UrlShortener.UrlMapping
  alias UrlShortenerEx.Cache

  action_fallback UrlShortenerExWeb.FallbackController

  def index(conn, _params) do
    url_mappings = UrlShortener.list_url_mappings()
    render(conn, :index, url_mappings: url_mappings)
  end

  def create(conn, %{"url_mapping" => url_mapping_params}) do
    with {:ok, %UrlMapping{} = url_mapping} <- UrlShortener.create_url_mapping(url_mapping_params) do
      # Add prefix to the short url
      decorated_url_mapping = decorate_short_url(url_mapping)
      # Insert the mapping into the cache
      case Cache.insert(url_mapping.short_url, url_mapping.original_url) do
        true -> IO.puts("Inserted #{url_mapping.short_url} into cache")
      end
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/url_mappings/#{url_mapping}")
      |> render(:show, url_mapping: decorated_url_mapping)
    end
  end

  def show(conn, %{"id" => id}) do
    url_mapping = UrlShortener.get_url_mapping!(id)
    render(conn, :show, url_mapping: url_mapping)
  end

  def update(conn, %{"id" => id, "url_mapping" => url_mapping_params}) do
    url_mapping = UrlShortener.get_url_mapping!(id)

    with {:ok, %UrlMapping{} = url_mapping} <- UrlShortener.update_url_mapping(url_mapping, url_mapping_params) do
      render(conn, :show, url_mapping: url_mapping)
    end
  end

  def delete(conn, %{"id" => id}) do
    url_mapping = UrlShortener.get_url_mapping!(id)

    with {:ok, %UrlMapping{}} <- UrlShortener.delete_url_mapping(url_mapping) do
      send_resp(conn, :no_content, "")
    end
  end

  defp decorate_short_url(url_mapping) do
    Map.put(url_mapping, :short_url, "http://localhost:4000/#{url_mapping.short_url}")
  end

end
