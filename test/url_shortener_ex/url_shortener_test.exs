defmodule UrlShortenerEx.UrlShortenerTest do
  use UrlShortenerEx.DataCase

  alias UrlShortenerEx.UrlShortener

  describe "url_mappings" do
    alias UrlShortenerEx.UrlShortener.UrlMapping

    import UrlShortenerEx.UrlShortenerFixtures

    @invalid_attrs %{short_url: nil, original_url: nil}

    test "list_url_mappings/0 returns all url_mappings" do
      url_mapping = url_mapping_fixture()
      assert UrlShortener.list_url_mappings() == [url_mapping]
    end

    test "get_url_mapping!/1 returns the url_mapping with given id" do
      url_mapping = url_mapping_fixture()
      assert UrlShortener.get_url_mapping!(url_mapping.id) == url_mapping
    end

    test "create_url_mapping/1 with valid data creates a url_mapping" do
      valid_attrs = %{short_url: "some short_url", original_url: "some original_url"}

      assert {:ok, %UrlMapping{} = url_mapping} = UrlShortener.create_url_mapping(valid_attrs)
      assert url_mapping.short_url == "some short_url"
      assert url_mapping.original_url == "some original_url"
    end

    test "create_url_mapping/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UrlShortener.create_url_mapping(@invalid_attrs)
    end

    test "update_url_mapping/2 with valid data updates the url_mapping" do
      url_mapping = url_mapping_fixture()
      update_attrs = %{short_url: "some updated short_url", original_url: "some updated original_url"}

      assert {:ok, %UrlMapping{} = url_mapping} = UrlShortener.update_url_mapping(url_mapping, update_attrs)
      assert url_mapping.short_url == "some updated short_url"
      assert url_mapping.original_url == "some updated original_url"
    end

    test "update_url_mapping/2 with invalid data returns error changeset" do
      url_mapping = url_mapping_fixture()
      assert {:error, %Ecto.Changeset{}} = UrlShortener.update_url_mapping(url_mapping, @invalid_attrs)
      assert url_mapping == UrlShortener.get_url_mapping!(url_mapping.id)
    end

    test "delete_url_mapping/1 deletes the url_mapping" do
      url_mapping = url_mapping_fixture()
      assert {:ok, %UrlMapping{}} = UrlShortener.delete_url_mapping(url_mapping)
      assert_raise Ecto.NoResultsError, fn -> UrlShortener.get_url_mapping!(url_mapping.id) end
    end

    test "change_url_mapping/1 returns a url_mapping changeset" do
      url_mapping = url_mapping_fixture()
      assert %Ecto.Changeset{} = UrlShortener.change_url_mapping(url_mapping)
    end
  end
end
