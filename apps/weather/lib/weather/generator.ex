defmodule Weather.Generator do
  use GenStage

  # Client
  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_weather(city) do
    GenStage.call(__MODULE__, {:weather, city})
  end

  # Server
  def init(:ok) do
    :ets.new(:weather_cache, [:named_table, read_concurrency: true])
    {:consumer, %{weathers: []}, subscribe_to: [Weather.FakeWeatherGen]}
  end

  def handle_call({:weather, city}, _from, state) do
    {w, new_state} = case :ets.lookup(:weather_cache, city) do
      [{^city, weather}] -> {weather, state}
      [] -> generate_and_save(city, state)
    end

    {:reply, w, [], new_state}
  end

  def handle_events(events, _from, state) do
    {:ok, weathers} = Map.fetch(state, :weathers)
    {:noreply, [], %{state | weathers: weathers ++ events}}
  end

  defp generate_and_save(city, state) do
    {:ok, weathers} = Map.fetch(state, :weathers)

    {:ok, w} = Enum.fetch(weathers, 0)
    new_state = %{state | weathers: Enum.drop(weathers, 1)}

    :ets.insert(:weather_cache, {city, w})
    {w, new_state}
  end

end
