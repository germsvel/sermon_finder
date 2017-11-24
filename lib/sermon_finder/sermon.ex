defmodule SermonFinder.Sermon do
  alias SermonFinder.{Passage, Sermon}

  defstruct [:url, :title, :author, :scripture_reference, :date, :type, :source]

  def new do
    %Sermon{}
  end

  def relevant_for_passage?(sermon, passage) do
    other_passage = Passage.new(sermon.scripture_reference)
    Passage.similar?(passage, other_passage)
  end

  def add_type(%Sermon{} = sermon, type) do
    %{sermon | type: type}
  end

  def add_title(%Sermon{} = sermon, title) do
    %{sermon | title: title}
  end

  def add_url(%Sermon{} = sermon, url) do
    %{sermon | url: url}
  end

  def add_scripture_ref(%Sermon{} = sermon, scripture_ref) do
    %{sermon | scripture_reference: scripture_ref}
  end

  def add_date(%Sermon{} = sermon, date) do
    %{sermon | date: date}
  end

  def add_author(%Sermon{} = sermon, author) do
    %{sermon | author: author}
  end

  def add_source(%Sermon{} = sermon, source) do
    %{sermon | source: source}
  end
end
