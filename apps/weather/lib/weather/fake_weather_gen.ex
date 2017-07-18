defmodule Weather.FakeWeatherGen  do
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:producer_consumer, %{numbers: []}, subscribe_to: [Weather.RandNumGen]}
  end

  def handle_events(events, _from, state) do
    {:ok, numbers} = Map.fetch(state, :numbers)

    new_nums = numbers ++ events

    {w, new_state} = if length(new_nums) >= 5 do
      {
        [generate_weather(Enum.take(new_nums, 5))],
        %{state | numbers: Enum.drop(new_nums, 5)},
      }
    else
      {[], %{state | numbers: new_nums}}
    end

    {:noreply, w, new_state}
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
