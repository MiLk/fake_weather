defmodule Weather.RandNumGen do
  use GenStage

  def start_link(initial \\ 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter), do: {:producer, counter}

  def handle_demand(demand, state) do
    events = Enum.map(state..state + demand - 1, fn _ -> :rand.uniform() end)
    {:noreply, events, (state + demand)}
  end
end
