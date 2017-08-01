defmodule Weather.Producer do
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_weather(city) do
    GenStage.call(__MODULE__, {:weather, city})
  end

  def init(:ok) do
    {:producer, nil}
  end

  def handle_call({:weather, city}, from, state) do
    {:noreply, [{:weather, city, from}], state} # Dispatch immediately
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state} # We don't care about the demand
  end
end
