defmodule UrlShortenerEx.Repo.Migrations.UpdateUrlMappings do
  use Ecto.Migration

  def change do
    alter table(:url_mappings) do
      remove :short_url_id
      add :short_url_id, :bigint
    end

    create unique_index(:url_mappings, [:short_url_id])
  end
end
