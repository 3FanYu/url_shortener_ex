defmodule UrlShortenerEx.Cache do
  use GenServer

  @name __MODULE__

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: @name)

  def init(_) do
    IO.puts("Creating ETS #{@name}")
    :ets.new(:short_url_mappings, [:named_table, :public])
    {:ok, "ETS Created"}
  end

  def insert(short_url, original_url) do
    :ets.insert(:short_url_mappings, {short_url, original_url})
  end

  def remove(short_url) do
    :ets.delete(:short_url_mappings, short_url)
  end

  def lookup(short_url) do
    :ets.lookup(:short_url_mappings, short_url)
  end
end
