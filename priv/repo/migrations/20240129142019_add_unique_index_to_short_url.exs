defmodule UrlShortenerEx.Repo.Migrations.AddUniqueIndexToShortUrl do
  use Ecto.Migration

  def change do
    create unique_index(:url_mappings, [:short_url])
  end
end
