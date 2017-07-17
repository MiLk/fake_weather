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
    {:consumer, %{numbers: [], weathers: []}, subscribe_to: [Weather.RNG]}
  end

  def handle_call({:weather, city}, _from, state) do
    {w, new_state} = case :ets.lookup(:weather_cache, city) do
      [{^city, weather}] -> {weather, state}
      [] -> generate_and_save(city, state)
    end

    {:reply, w, [], new_state}
  end

  def handle_events(events, _from, state) do
    {:ok, numbers} = Map.fetch(state, :numbers)
    {:ok, weathers} = Map.fetch(state, :weathers)

    new_rand_nums = numbers ++ events

    new_state = if length(new_rand_nums) > 5 do
      %{
        numbers: Enum.drop(new_rand_nums, 5),
        weathers: weathers ++ [generate_weather(Enum.take(new_rand_nums, 5))],
      }
    else
      %{state | numbers: new_rand_nums}
    end

    {:noreply, [], new_state}
  end

  defp generate_and_save(city, state) do
    {:ok, weathers} = Map.fetch(state, :weathers)

    [w] = Enum.take(weathers, 1)
    new_state = %{state | weathers: Enum.drop(weathers, 1)}

    :ets.insert(:weather_cache, {city, w})
    {w, new_state}
  end

  defp generate_weather(rand_nums) do
     temp = Float.round(Enum.at(rand_nums, 0) * 40, 2)
     %{
        temp: temp,
        pressure: Float.round(900 + Enum.at(rand_nums, 1) * 200, 2),
        humidity: Float.round(10 + Enum.at(rand_nums, 2) * 80, 2),
        temp_min: Float.round(temp - Enum.at(rand_nums, 3) * 5, 2),
        temp_max: Float.round(temp + Enum.at(rand_nums, 4) * 5, 2),
     }
  end
end
