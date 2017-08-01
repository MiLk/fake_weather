defmodule Weather do
  @moduledoc """
  Documentation for Weather.
  """

  def get_weather(city) do
    Weather.Producer.get_weather(city)
  end
end
