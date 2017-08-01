defmodule Weather.Generator do
  use GenServer

  # Client
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_weather(city) do
    GenServer.call(__MODULE__, {:weather, city})
  end

  # Server
  def init(:ok) do
    :ets.new(:weather_cache, [:named_table, read_concurrency: true])
    {:ok, %{}}
  end

  def handle_call({:weather, city}, _from, state) do
    w = case :ets.lookup(:weather_cache, city) do
      [{^city, weather}] -> weather
      [] -> generate_and_save(city)
    end
    {:reply, w, state}
  end

  defp generate_and_save(city) do
    w = weather_for(city)
    :ets.insert(:weather_cache, {city, w})
    w
  end

  defp weather_for(_city) do
     temp = Float.round(:rand.uniform() * 40, 2)
     %{
        temp: temp,
        pressure: Float.round(900 + :rand.uniform() * 200, 2),
        humidity: Float.round(10 + :rand.uniform() * 80, 2),
        temp_min: Float.round(temp - :rand.uniform() * 5, 2),
        temp_max: Float.round(temp + :rand.uniform() * 5, 2),
     }
  end
end
