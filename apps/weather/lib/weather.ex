defmodule Weather do
  @moduledoc """
  Documentation for Weather.
  """

  def get_weather(city) do
    Weather.Generator.get_weather(city)
  end
end
