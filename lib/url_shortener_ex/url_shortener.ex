defmodule UrlShortenerEx.UrlShortener do
  @moduledoc """
  The UrlShortener context.
  """

  import Ecto.Query, warn: false
  alias UrlShortenerEx.Repo

  alias UrlShortenerEx.UrlShortener.UrlMapping

  @doc """
  Returns the list of url_mappings.

  ## Examples

      iex> list_url_mappings()
      [%UrlMapping{}, ...]

  """
  def list_url_mappings do
    Repo.all(UrlMapping)
  end

  @doc """
  Gets a single url_mapping.

  Raises `Ecto.NoResultsError` if the Url mapping does not exist.

  ## Examples

      iex> get_url_mapping!(123)
      %UrlMapping{}

      iex> get_url_mapping!(456)
      ** (Ecto.NoResultsError)

  """
  def get_url_mapping!(id), do: Repo.get!(UrlMapping, id)

  @doc """
  Creates a url_mapping.

  ## Examples

      iex> create_url_mapping(%{field: value})
      {:ok, %UrlMapping{}}

      iex> create_url_mapping(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_url_mapping(attrs \\ %{}) do
    updated_attrs = Map.put(attrs, "short_url", generate_short_url())
    %UrlMapping{}
    |> UrlMapping.changeset(updated_attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a url_mapping.

  ## Examples

      iex> update_url_mapping(url_mapping, %{field: new_value})
      {:ok, %UrlMapping{}}

      iex> update_url_mapping(url_mapping, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_url_mapping(%UrlMapping{} = url_mapping, attrs) do
    url_mapping
    |> UrlMapping.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a url_mapping.

  ## Examples

      iex> delete_url_mapping(url_mapping)
      {:ok, %UrlMapping{}}

      iex> delete_url_mapping(url_mapping)
      {:error, %Ecto.Changeset{}}

  """
  def delete_url_mapping(%UrlMapping{} = url_mapping) do
    Repo.delete(url_mapping)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking url_mapping changes.

  ## Examples

      iex> change_url_mapping(url_mapping)
      %Ecto.Changeset{data: %UrlMapping{}}

  """
  def change_url_mapping(%UrlMapping{} = url_mapping, attrs \\ %{}) do
    UrlMapping.changeset(url_mapping, attrs)
  end


  @doc """
  Gets a single url_mapping.

  Raises `Ecto.NoResultsError` if the Url mapping does not exist.

  ## Examples

      iex> get_url_mapping_by_short_url!("1rU1va")
      %UrlMapping{}

      iex> get_url_mapping_by_short_url!("something_not_exist")
      ** (Ecto.NoResultsError)
  """
  def get_url_mapping_by_short_url!(short_url) do
    Repo.get_by(UrlMapping, short_url: short_url)
  end

  @doc """
  Deletes all `UrlMapping` records from the database that were created before the specified `cutoff_time`.

  Returns a tuple `{:ok, count}` where `count` is the number of records deleted from the database.

  ## Examples
      iex> MyApp.UrlShortener.delete_old_url_mappings(~U[2023-01-01T00:00:00Z])
      {:ok, 3}
  """
  def delete_old_url_mappings(%DateTime{} = cutoff_time) do
    # Define a query to select records older than cutoff_time
    query = from u in UrlMapping, where: u.inserted_at < ^cutoff_time

    # Delete the records
    Repo.delete_all(query)
  end

  defp generate_short_url do
    current_pid = self()
    |> inspect()
    |> String.split(".")
    |> Enum.at(1)

    DateTime.utc_now()
    |> DateTime.to_unix()
    |> Integer.to_string()
    |> (fn timestamp_string -> "#{timestamp_string}#{current_pid}" end).()
    |> String.to_integer()
    |> Base62.encode()
  end
end
