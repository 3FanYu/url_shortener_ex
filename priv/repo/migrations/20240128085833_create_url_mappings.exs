defmodule UrlShortenerEx.Repo.Migrations.CreateUrlMappings do
  use Ecto.Migration

  def change do
    create table(:url_mappings) do
      add :short_url, :string
      add :original_url, :string

      timestamps()
    end
  end
end
