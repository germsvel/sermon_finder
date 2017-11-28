defmodule SermonFinder.Organization.DesiringGod do
  alias SermonFinder.{Sermon, HTTPClient, Passage}

  @base_url "https://www.desiringgod.org"

  def find(passage) do
    passage
    |> generate_url()
    |> request_page()
    |> process_response()
    |> filter_resources_by_passage(passage)
  end

  defp generate_url(passage) do
    chapter = Passage.chapter(passage.from)
    full_url("/scripture/#{passage.book}/#{chapter}/messages")
  end

  defp full_url(relative_url) do
    @base_url <> relative_url
  end

  defp request_page(url) do
    {:ok, body} = HTTPClient.get(url)
    body
  end

  defp process_response(nil), do: ""
  defp process_response(body) do
    body
    |> Floki.find(".card-list-view")
    |> Floki.find(".card--resource")
    |> Enum.map(&create_resource/1)
  end

  defp create_resource(html_tree) do
    Sermon.new
    |> Sermon.add_type(:sermon)
    |> Sermon.add_source("Desiring God")
    |> add_title(html_tree)
    |> add_url(html_tree)
    |> add_scripture_ref(html_tree)
    |> add_date(html_tree)
    |> add_author(html_tree)
  end

  defp add_url(resource, html_tree) do
    [relative_url] =
      Floki.find(html_tree, ".card__shadow")
      |> Floki.attribute("href")
      |> Enum.take(1)

    url = full_url(relative_url)
    Sermon.add_url(resource, url)
  end
  defp add_title(resource, html_tree) do
    Sermon.add_title(resource, search_tree(html_tree, ".card--resource__title"))
  end
  defp add_scripture_ref(resource, html_tree) do
    ref =
      search_tree(html_tree, ".card--resource__scripture")
      |> String.replace("Scripture: ", "")
      |> String.replace("–", "-")

    Sermon.add_scripture_ref(resource, ref)
  end
  defp add_date(resource, html_tree) do
    Sermon.add_date(resource, search_tree(html_tree, ".card--resource__date"))
  end
  defp add_author(resource, html_tree) do
    author =
      html_tree
      |> search_tree(".card__author")
      |> String.trim()

    Sermon.add_author(resource, author)
  end

  defp search_tree(html_tree, css_selector) do
    html_tree
    |> Floki.find(css_selector)
    |> Floki.text()
    |> String.trim()
  end

  defp filter_resources_by_passage(sermons, passage) do
    Enum.filter(sermons, fn(sermon) ->
      Sermon.relevant_for_passage?(sermon, passage)
    end)
  end
end
