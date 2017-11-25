defmodule SermonFinder.VerseTest do
  use ExUnit.Case, async: true

  alias SermonFinder.Verse

  describe ".to_thousand_format/2" do
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

  describe ".from_thousand_format/2" do
    test "turns 3_023 into {3, 23}" do
      {chapter, verse} = Verse.from_thousand_format(3_023)

      assert chapter == 3
      assert verse == 23
    end

    test "turns 3_003 into {3, 3}" do
      {chapter, verse} = Verse.from_thousand_format(3_003)

      assert chapter == 3
      assert verse == 3
    end

    test "turns 3_152 into {3, 152}" do
      {chapter, verse} = Verse.from_thousand_format(3_152)

      assert chapter == 3
      assert verse == 152
    end
  end
end
