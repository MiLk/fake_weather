defmodule Api.Router do
  @moduledoc false

  use Plug.Router

  if Mix.env == :dev do
    use Plug.Debugger
  end

  plug Plug.RequestId
  plug Plug.Logger, log: :debug
  plug :match
  plug :dispatch

  get "/weather.json" do
     with {:ok, query_params = %{}} <- conn
          |> fetch_query_params()
          |> Map.fetch(:query_params),
         {:ok, city} <- Map.fetch(query_params, "city"),
         result = Weather.get_weather(city),
         {:ok, json} <- Poison.encode(result) do
      send_resp(conn, 200, json)
     else
      {:error, err} -> send_resp(conn, 500, err)
      :error -> send_resp(conn, 500, "An unexpected error occured.")
     end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
