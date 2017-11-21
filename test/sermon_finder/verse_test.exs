defmodule SermonFinder.VerseTest do
  use ExUnit.Case, async: true

  alias SermonFinder.Verse

  # .to_thousand_format
  test "turns 3, 23 into 3_023" do
    verse = Verse.to_thousand_format(3, 23)

    assert verse == 3_023
  end

  test "turns 3, 2 into 3_002" do
    verse = Verse.to_thousand_format(3, 2)

    assert verse == 3_002
  end

  test "turns 3, 152 into 3_152" do
    verse = Verse.to_thousand_format(3, 152)

    assert verse == 3_152
  end

  test "works with string arguments" do
    verse = Verse.to_thousand_format("3", "152")

    assert verse == 3_152
  end
end
