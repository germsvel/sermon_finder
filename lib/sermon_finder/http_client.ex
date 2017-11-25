defmodule SermonFinder.HTTPClient do
  def get(url) do
    case HTTPoison.get(url, [], [follow_redirect: true]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, 404}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
      error ->
        {:error, "Could not retrieve #{url}. Error: #{error}"}
    end
  end
end
