defmodule UrlShortenerEx.UrlShortenerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UrlShortenerEx.UrlShortener` context.
  """

  @doc """
  Generate a url_mapping.
  """
  def url_mapping_fixture(attrs \\ %{}) do
    {:ok, url_mapping} =
      attrs
      |> Enum.into(%{
        original_url: "some original_url",
        short_url: "some short_url"
      })
      |> UrlShortenerEx.UrlShortener.create_url_mapping()

    url_mapping
  end
end
