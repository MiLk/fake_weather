# Api

Expose an HTTP API to query weather for a given city.

```
$ curl -s 127.0.0.1:8000/weather.json?city=Paris | jq
{
  "temp_min": 23.76,
  "temp_max": 25.31,
  "temp": 25.21,
  "pressure": 937.68,
  "humidity": 65.3
}

$ curl -s 127.0.0.1:8000/weather.json?city=Madrid | jq
{
  "temp_min": -1.05,
  "temp_max": 4.32,
  "temp": 0.88,
  "pressure": 1039.69,
  "humidity": 81.18
}
```
