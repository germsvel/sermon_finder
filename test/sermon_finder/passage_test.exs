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

  describe ".compare/2" do
    test "returns true when the passages are the same" do
      passage = Passage.new("Romans 3:23-25")

      similar = Passage.new("Romans 3:23-25")
              |> Passage.compare(passage)

      assert similar
    end

    test "returns false when passages have different books" do
      passage = Passage.new("James 3:12")

      similar = Passage.new("Romans 3:12")
              |> Passage.compare(passage)

      refute similar
    end

    test "returns false when passages have different chapters" do
      passage = Passage.new("Romans 4:12")

      similar = Passage.new("Romans 3:12")
              |> Passage.compare(passage)

      refute similar
    end

    test "returns false when first_verse is >= 2 away from the original.first_verse" do
      passage = Passage.new("Romans 3:10-15")

      similar = Passage.new("Romans 3:12-15")
              |> Passage.compare(passage)

      refute similar
    end

    test "returns false when last_verse is >= 2 away from the original.last_verse" do
      passage = Passage.new("Romans 3:9-14")

      similar = Passage.new("Romans 3:9-12")
              |> Passage.compare(passage)

      refute similar
    end
  end
end
