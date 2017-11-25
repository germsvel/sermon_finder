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

  def from_thousand_format(ch_verse) when is_integer(ch_verse) do
    split_ch_and_verse(Integer.digits(ch_verse))
  end

  defp split_ch_and_verse([ch, a, b, c]) do
    {ch, String.to_integer("#{a}#{b}#{c}")}
  end
end
