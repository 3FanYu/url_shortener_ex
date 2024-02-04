defmodule MyApp.UrlCleaner do
  use GenServer

  alias UrlShortenerEx.UrlShortener

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do

    DateTime.utc_now()
    |> DateTime.add(-20 * 60, :second)
    |> UrlShortener.delete_old_url_mappings()
    IO.puts("Deleted old url mappings")

    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 20 * 60 * 1000) # In 20 minutes
  end
end
