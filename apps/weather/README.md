# Weather

Generate Weather data for a given city.

```
iex> Weather.get_weather("Paris")
%{humidity: 65.3, pressure: 937.68, temp: 25.21, temp_max: 25.31,
  temp_min: 23.76}

iex> Weather.get_weather("Madrid")
%{humidity: 81.18, pressure: 1039.69, temp: 0.88, temp_max: 4.32,
  temp_min: -1.05}
```
