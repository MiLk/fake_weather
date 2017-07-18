defmodule Weather.FakeWeatherGenTest do
  use ExUnit.Case, async: true

  test "fake weathers should be generated from numbers from the state" do
    numbers = [1.0, 2.0, 3.0, 4.0, 5.0]
    w = Weather.FakeWeatherGen.generate_weather(numbers)

    {:noreply, [fw], new_state} =
      Weather.FakeWeatherGen.handle_events(numbers, self(), %{numbers: []})
    {:ok, s_numbers} = Map.fetch(new_state, :numbers)

    assert s_numbers == []
    assert w == fw
  end
end
