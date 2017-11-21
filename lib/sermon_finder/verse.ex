defmodule SermonFinder.Verse do
  def to_thousand_format(chapter, verse) when is_binary(verse) do
    to_thousand_format(chapter, String.to_integer(verse))
  end

  def to_thousand_format(chapter, verse) when is_integer(verse) do
    String.to_integer("#{chapter}#{format_verse(verse)}")
  end

  defp format_verse(verse) when verse < 10, do: "00#{verse}"
  defp format_verse(verse) when verse < 100, do: "0#{verse}"
  defp format_verse(verse) when verse < 1000, do: verse
end
