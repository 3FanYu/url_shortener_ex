defmodule UrlShortenerEx.Repo.Migrations.AddUniqueIdAndDeleteShortUrlToUrlMappings do
  use Ecto.Migration

  def change do
    alter table(:url_mappings) do
      remove :short_url
      add :short_url_id, :integer
    end

    create unique_index(:url_mappings, [:short_url_id])
  end
end
