defmodule Weather.Consumer do
  require Logger
  use GenStage

  def start_link do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:consumer, nil, subscribe_to: [{ Weather.Producer, max_demand: 10 }] }
  end

  def handle_events(events, _from, state) do
    :ok = Enum.each(events, fn({:weather, city, event_from}) ->
      reply = Weather.Generator.get_weather(city)
      :ok = GenStage.reply(event_from, reply)
    end)

    # We are a consumer, so we would never emit items.
    {:noreply, [], state}
  end
end
