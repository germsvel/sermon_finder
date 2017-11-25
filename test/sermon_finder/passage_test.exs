defmodule SermonFinder.PassageTest do
  use ExUnit.Case, async: true

  alias SermonFinder.Passage

  describe "new/1" do
    test "returns an empty struct if no passage is provided" do
      passage = Passage.new(nil)

      assert passage == %Passage{}
    end

    test "returns an empty struct if an empty string is provided" do
      passage = Passage.new("")

      assert passage == %Passage{}
    end

    test "creates a passage struct from the query" do
      passage = Passage.new("Romans 3:23-25")

      assert passage.original == "Romans 3:23-25"
      assert passage.book == "Romans"
      assert passage.from == 3_023
      assert passage.to == 3_025
    end

    test "creates a passage for single verse queries (e.g. Rom 3:23)" do
      passage = Passage.new("Romans 3:23")

      assert passage.original == "Romans 3:23"
      assert passage.book == "Romans"
      assert passage.from == 3_023
      assert passage.to == 3_023
    end

    test "creates a new passage for books with numbers (e.g. 1 Cor 1:13)" do
      passage = Passage.new("1 Corinthians 1:13")

      assert passage.original == "1 Corinthians 1:13"
      assert passage.book == "1 Corinthians"
      assert passage.from == 1_013
      assert passage.to == 1_013
    end

    test "creates a new passage for queries that includes future chapters" do
      passage = Passage.new("Romans 3:23-4:2")

      assert passage.original == "Romans 3:23-4:2"
      assert passage.book == "Romans"
      assert passage.from == 3_023
      assert passage.to == 4_002
    end

    test "creates a new passage for queries whole book searches (e.g. Romans 3)" do
      passage = Passage.new("Romans 3")

      assert passage.original == "Romans 3"
      assert passage.book == "Romans"
      assert passage.from == 3_000
      assert passage.to == 3_500
    end
  end

  describe ".chapter/1" do
    test "returns chapter portion of chapter-verse combination" do
      passage = Passage.new("Romans 3:23-25")

      assert Passage.chapter(passage.from) == 3
    end
  end

  describe ".similar?/2" do
    test "returns true when the passages are the same" do
      passage = Passage.new("Romans 3:23-25")
      other_passage = Passage.new("Romans 3:23-25")

      assert Passage.similar?(passage, other_passage)
    end

    test "returns true when the passages are the same and only one verse" do
      passage = Passage.new("Romans 3:23")
      other_passage = Passage.new("Romans 3:23")

      assert Passage.similar?(passage, other_passage)
    end

    test "returns false when passages have different books" do
      passage = Passage.new("Romans 3:12")
      other_passage = Passage.new("James 3:12")

      refute Passage.similar?(passage, other_passage)
    end

    test "returns false when passages have different chapters" do
      passage = Passage.new("Romans 3:12")
      other_passage = Passage.new("Romans 4:12")

      refute Passage.similar?(passage, other_passage)
    end

    test "returns true when last verse matches" do
      passage = Passage.new("Romans 3:12-15")
      other_passage = Passage.new("Romans 3:10-15")

      assert Passage.similar?(passage, other_passage)
    end

    test "returns true when first verse matches" do
      passage = Passage.new("Romans 3:9-12")
      other_passage = Passage.new("Romans 3:9-14")

      assert Passage.similar?(passage, other_passage)
    end

    test "returns true when the left-side portion overlaps" do
      passage = Passage.new("Romans 3:9-12")
      other_passage = Passage.new("Romans 3:7-10")

      assert Passage.similar?(passage, other_passage)
    end

    test "returns true when the right-side portion overlaps" do
      passage = Passage.new("Romans 3:9-12")
      other_passage = Passage.new("Romans 3:10-14")

      assert Passage.similar?(passage, other_passage)
    end

    test "returns false if no portion of verses overlap" do
      passage = Passage.new("Romans 3:9-12")
      other_passage = Passage.new("Romans 3:1-8")

      refute Passage.similar?(passage, other_passage)
    end

    test "returns true when the passage is contained within the other passage" do
      passage = Passage.new("Romans 3:20-23")
      other_passage = Passage.new("Romans 3:1-27")

      assert Passage.similar?(passage, other_passage)
    end

    test "returns false when passage is broader than the other passage" do
      passage  = Passage.new("Romans 3:1-27")
      other_passage = Passage.new("Romans 3:20-23")

      refute Passage.similar?(passage, other_passage)
    end
  end
end
