defmodule Oscar.BoardTest do
  use Oscar.DataCase

  describe "boards" do
    alias Oscar.Board

    test "new/1 returns an empty board" do
      assert Board.new({ 2, 2 }) == [[ nil, nil], [  nil, nil]]
    end

    test "new/1 returns an board" do
      assert Board.new({ 3, 2 }, "X") == [[ "X", "X", "X"], [ "X", "X", "X"]]
    end

    test "to_string/1 replaces non trailing empty points with space" do
      assert Board.to_string([[ nil, nil], [ "5", "6"]]) ==
      """

      56
      """

      assert Board.to_string([[ nil, "X"], [ "5", "6"]]) ==
      """
       X
      56
      """

      assert Board.to_string([[ nil, "X", nil], [ "4", "5", "6"]]) ==
      """
       X
      456
      """
    end

    test "to_string/1 without spaces" do
      assert Board.to_string([[ "1", "2", "3"], [ "4", "5", "6"]]) ==
      """
      123
      456
      """
    end

    test "add_rect with empty rect does nothing" do
      actual = Board.new({ 3, 2 }, "X") |> Board.add_rect({ 0, 1 }, { 0, 0 }, "Y") |> Board.to_string()
      assert actual ==
      """
      XXX
      XXX
      """

      actual = Board.new({ 3, 2 }, "X") |> Board.add_rect({ 0, 1 }, { 0, 3 }, "Y") |> Board.to_string()
      assert actual ==
      """
      XXX
      XXX
      """

      actual = Board.new({ 3, 2 }, "X") |> Board.add_rect({ 0, 1 }, { 3, 0 }, "Y") |> Board.to_string()
      assert actual ==
      """
      XXX
      XXX
      """
    end

    test "add_rect adding a rect outside the canvas is ignored" do
      actual = Board.new({ 3, 2 }, "X") |> Board.add_rect({ 4, 4 }, { 2, 2 }, "Y") |> Board.to_string()
      assert actual ==
      """
      XXX
      XXX
      """
    end

    test "add_rect adding a rect with negative arguments is ignored" do
      actual = Board.new({ 3, 2 }, "X") |> Board.add_rect({ -1, 0 }, { 1, 1 }, "Y") |> Board.to_string()
      assert actual ==
      """
      XXX
      XXX
      """

      actual = Board.new({ 3, 2 }, "X") |> Board.add_rect({ 0, -1 }, { 1, 1 }, "Y") |> Board.to_string()
      assert actual ==
      """
      XXX
      XXX
      """

      actual = Board.new({ 3, 2 }, "X") |> Board.add_rect({ 0, 0 }, { -1, 1 }, "Y") |> Board.to_string()
      assert actual ==
      """
      XXX
      XXX
      """

      actual = Board.new({ 3, 2 }, "X") |> Board.add_rect({ 0, 0 }, { 1, -1 }, "Y") |> Board.to_string()
      assert actual ==
      """
      XXX
      XXX
      """

    end

    test "add_rect adds fill to board" do
      actual = Board.new({ 3, 2 }, "X") |> Board.add_rect({ 0, 0 }, { 2, 1 }, "Y") |> Board.to_string()
      assert actual ==
      """
      YYX
      XXX
      """
    end

    test "add_rect adds fill and without overlapping" do
      actual = Board.new({ 3, 2 }, "X") |> Board.add_rect({ 2, 0 }, { 2, 1 }, "Y") |> Board.to_string()
      assert actual ==
      """
      XXY
      XXX
      """
    end

    test "add_rect with invalid args does not add rect to board " do
      actual = Board.new({ 3, 2 }, "X")
      |> Board.add_rect({ 4, 2 }, { 2, 1 }, "Y")
      |> Board.to_string()

      assert actual ==
      """
      XXX
      XXX
      """
    end

    test "add_rect with outline only" do
      actual = Board.new({ 5, 5 }, "X")
      |> Board.add_rect({ 0, 0 }, { 3, 3 }, nil, "Y")
      |> Board.to_string()

      assert actual ==
      """
      YYYXX
      YXYXX
      YYYXX
      XXXXX
      XXXXX
      """
    end

    test "add_rect with outline and fill" do
      actual = Board.new({ 5, 5 }, "X")
      |> Board.add_rect({ 0, 0 }, { 3, 3 }, "Z", "Y")
      |> Board.to_string()

      assert actual ==
      """
      YYYXX
      YZYXX
      YYYXX
      XXXXX
      XXXXX
      """
    end

    test "add_rect with outline and no space for fill" do
      actual = Board.new({ 5, 5 }, "X")
      |> Board.add_rect({ 0, 0 }, { 2, 3 }, "Z", "Y")
      |> Board.to_string()

      assert actual ==
      """
      YYXXX
      YYXXX
      YYXXX
      XXXXX
      XXXXX
      """
    end

    test "add_flood on empty point" do
      actual = Board.new({ 5, 5 })
      |> Board.add_rect({ 0, 1 }, { 5, 3 }, nil, "O")
      |> Board.add_flood({ 1, 2 }, "F")
      |> Board.to_string()

      assert actual ==
      """

      OOOOO
      OFFFO
      OOOOO

      """
    end

    test "add_flood on empty point with negative coordinates is ignored" do
      actual = Board.new({ 5, 5 })
      |> Board.add_rect({ 0, 1 }, { 5, 3 }, nil, "O")
      |> Board.add_flood({ -2, 1 }, "F")
      |> Board.to_string()

      assert actual ==
      """

      OOOOO
      O   O
      OOOOO

      """
    end


    test "add_flood on non empty point" do
      actual = Board.new({ 5, 5 })
      |> Board.add_rect({ 0, 1 }, { 5, 3 }, ".", "O")
      |> Board.add_flood({ 1, 2 }, "F")
      |> Board.to_string()

      assert actual ==
      """

      OOOOO
      OFFFO
      OOOOO

      """
    end

    test "fixture 1/1" do
      actual = Board.new({ 24, 9 })
      |> Board.add_rect({ 10, 3 }, { 14, 6 }, "o", "x")
      |> Board.to_string()

      assert actual ==
      """



                xxxxxxxxxxxxxx
                xoooooooooooox
                xoooooooooooox
                xoooooooooooox
                xoooooooooooox
                xxxxxxxxxxxxxx
      """
    end


    test "fixture 1" do
      actual = Board.new({ 24, 9 })
      |> Board.add_rect({ 3, 2 }, { 5, 3 }, "X", "@")
      |> Board.add_rect({ 10, 3 }, { 14, 6 }, "o", "x")
      |> Board.to_string()

      assert actual ==
      """


         @@@@@
         @XXX@  xxxxxxxxxxxxxx
         @@@@@  xoooooooooooox
                xoooooooooooox
                xoooooooooooox
                xoooooooooooox
                xxxxxxxxxxxxxx
      """
    end


    test "fixture 2/1" do
      actual = Board.new({ 21, 8 })
      |> Board.add_rect({ 14, 0 }, { 7, 6 }, ".")
      |> Board.to_string()
      assert actual ==
     """
                   .......
                   .......
                   .......
                   .......
                   .......
                   .......


     """
    end

    test "fixture 2" do
      actual = Board.new({ 21, 8 })
      |> Board.add_rect({ 14, 0 }, { 7, 6 }, ".")
      |> Board.add_rect({ 0, 3 }, { 8, 4 }, nil, "o")
      |> Board.add_rect({ 5, 5 }, { 5, 3 }, "x", "x")
      |> Board.to_string()
      assert actual ==
     """
                   .......
                   .......
                   .......
     oooooooo      .......
     o      o      .......
     o    xxxxx    .......
     oooooxxxxx
          xxxxx
     """
    end

    test "fixture 3" do
      actual = Board.new({ 21, 8 })
      |> Board.add_rect({ 14, 0 }, { 7, 6 }, ".")
      |> Board.add_rect({ 0, 3 }, { 8, 4 }, nil, "o")
      |> Board.add_rect({ 5, 5 }, { 5, 3 }, "x", "x")
      |> Board.add_flood({ 0, 0 }, "-")
      |> Board.to_string()
      assert actual ==
      """
      --------------.......
      --------------.......
      --------------.......
      oooooooo------.......
      o      o------.......
      o    xxxxx----.......
      oooooxxxxx-----------
           xxxxx-----------
      """
    end
  end
end
