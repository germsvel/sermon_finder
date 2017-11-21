defmodule SermonFinder.Passage do
  alias SermonFinder.{Passage, Verse}

  defstruct [:book, :original, :from, :to]

  @verses_for_entire_chapter "0-500"

  def new(nil), do: %Passage{}
  def new(""), do: %Passage{}
  def new(original) do
    {book, from, to} = parse_original(original)
    %Passage{
      original: original,
      book: book,
      from: from,
      to: to
    }
  end

  defp parse_original(original) do
    {book, rest} = split_book(original)
    {from, to} = split_chapter_and_verses(rest)

    {book, from, to}
  end

  defp split_book(original) do
    case String.split(original, " ") do
      [book, rest] -> {book, rest}
      [book_num, book_name, rest] -> {"#{book_num} #{book_name}", rest}
    end
  end

  defp split_chapter_and_verses(chapter_and_verses) do
    case String.split(chapter_and_verses, ":") do
      [chapter] ->
        parse_chapter_and_verses(chapter, @verses_for_entire_chapter)
      [chapter, verses] ->
        parse_chapter_and_verses(chapter, verses)
      [chapter, verse_next_chapter, final_verse] ->
        parse_chapter_and_verses(chapter, verse_next_chapter, final_verse)
    end
  end

  defp parse_chapter_and_verses(chapter, verses) do
    {first, last} = split_verses(verses)

    from = Verse.to_thousand_format(chapter, first)
    to = Verse.to_thousand_format(chapter, last)
    {from, to}
  end

  defp parse_chapter_and_verses(chapter, verse_next_chapter, final_verse) do
    {first_verse, next_chapter} = split_verses(verse_next_chapter)

    from = Verse.to_thousand_format(chapter, first_verse)
    to = Verse.to_thousand_format(next_chapter, final_verse)
    {from, to}
  end

  defp split_verses(verses) do
    case String.split(verses, "-") do
      [first, last] -> {first, last}
      [only_verse] -> {only_verse, only_verse}
    end
  end

  def compare(passage, scripture_ref) do
    passage2 = new(scripture_ref)
    passage.book == passage2.book &&
    compare_verses(passage, passage2)
  end

  defp compare_verses(passage, passage2) do
    ((passage.from == passage2.from) && within(passage.to, passage2.to, 2)) ||
    ((passage.to == passage2.to) && within(passage.from, passage2.from, 2))
  end

  defp within(num1, num2, tolerance) do
    abs(num1 - num2) < tolerance
  end
end
