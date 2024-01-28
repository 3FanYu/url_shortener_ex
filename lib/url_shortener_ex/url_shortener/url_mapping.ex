defmodule UrlShortenerEx.UrlShortener.UrlMapping do
  use Ecto.Schema
  import Ecto.Changeset

  schema "url_mappings" do
    field :short_url, :string
    field :original_url, :string

    timestamps()
  end

  @doc false
  def changeset(url_mapping, attrs) do
    url_mapping
    |> cast(attrs, [:short_url, :original_url])
    |> validate_required([:short_url, :original_url])
  end
end
