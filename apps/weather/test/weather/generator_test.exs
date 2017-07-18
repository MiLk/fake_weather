defmodule Weather.GeneratorTest do
  use ExUnit.Case, async: true

  test "weather should be generated and cached correctly" do
    city = "Tokyo"
    w = Weather.Generator.get_weather(city)

    assert Weather.Generator.get_weather(city) == w
  end

  test "weathers should be added to the state correctly" do
    initial_state = %{weathers: ["W1", "W2"]}
    events = ["W3", "W4"]

    {:noreply, _r, new_state} = Weather.Generator.handle_events(events, self(), initial_state)

    assert new_state == %{weathers: ["W1", "W2", "W3", "W4"]}
  end

  test "weathers should be obtained from the state" do
    {:ok, state} = Map.fetch(:sys.get_state(Weather.Generator), :state)
    {:ok, weathers} = Map.fetch(state, :weathers)
    {:ok, sw1} = Enum.fetch(weathers, 0)
    {:ok, sw2} = Enum.fetch(weathers, 1)

    w1 = Weather.Generator.get_weather("Madrid")
    w2 = Weather.Generator.get_weather("Barcelona")

    assert w1 == sw1
    assert w2 == sw2
  end

end
