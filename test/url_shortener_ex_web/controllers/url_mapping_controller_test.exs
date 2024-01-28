defmodule UrlShortenerExWeb.UrlMappingControllerTest do
  use UrlShortenerExWeb.ConnCase

  import UrlShortenerEx.UrlShortenerFixtures

  alias UrlShortenerEx.UrlShortener.UrlMapping

  @create_attrs %{
    short_url: "some short_url",
    original_url: "some original_url"
  }
  @update_attrs %{
    short_url: "some updated short_url",
    original_url: "some updated original_url"
  }
  @invalid_attrs %{short_url: nil, original_url: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all url_mappings", %{conn: conn} do
      conn = get(conn, ~p"/api/url_mappings")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create url_mapping" do
    test "renders url_mapping when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/url_mappings", url_mapping: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/url_mappings/#{id}")

      assert %{
               "id" => ^id,
               "original_url" => "some original_url",
               "short_url" => "some short_url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/url_mappings", url_mapping: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update url_mapping" do
    setup [:create_url_mapping]

    test "renders url_mapping when data is valid", %{conn: conn, url_mapping: %UrlMapping{id: id} = url_mapping} do
      conn = put(conn, ~p"/api/url_mappings/#{url_mapping}", url_mapping: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/url_mappings/#{id}")

      assert %{
               "id" => ^id,
               "original_url" => "some updated original_url",
               "short_url" => "some updated short_url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, url_mapping: url_mapping} do
      conn = put(conn, ~p"/api/url_mappings/#{url_mapping}", url_mapping: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete url_mapping" do
    setup [:create_url_mapping]

    test "deletes chosen url_mapping", %{conn: conn, url_mapping: url_mapping} do
      conn = delete(conn, ~p"/api/url_mappings/#{url_mapping}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/url_mappings/#{url_mapping}")
      end
    end
  end

  defp create_url_mapping(_) do
    url_mapping = url_mapping_fixture()
    %{url_mapping: url_mapping}
  end
end
