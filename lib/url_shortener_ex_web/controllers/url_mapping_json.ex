defmodule UrlShortenerExWeb.UrlMappingJSON do
  alias UrlShortenerEx.UrlShortener.UrlMapping

  @doc """
  Renders a list of url_mappings.
  """
  def index(%{url_mappings: url_mappings}) do
    %{data: for(url_mapping <- url_mappings, do: data(url_mapping))}
  end

  @doc """
  Renders a single url_mapping.
  """
  def show(%{url_mapping: url_mapping}) do
    %{data: data(url_mapping)}
  end

  defp data(%UrlMapping{} = url_mapping) do
    %{
      id: url_mapping.id,
      short_url: url_mapping.short_url,
      original_url: url_mapping.original_url
    }
  end
end
