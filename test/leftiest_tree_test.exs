defmodule Heap.LeftiestTreeTest do
  use ExUnit.Case
  doctest Heap.LeftiestTree

  alias Heap.LeftiestTree

  test "tree" do
    t =
      LeftiestTree.single(1)
      |> LeftiestTree.merge(LeftiestTree.single(2))
      |> LeftiestTree.merge(LeftiestTree.single(-1))
      |> LeftiestTree.merge(LeftiestTree.single(7))
      |> LeftiestTree.merge(LeftiestTree.single(-3))
      |> LeftiestTree.merge(LeftiestTree.single(2))
      |> LeftiestTree.merge(LeftiestTree.single(-1))

    assert LeftiestTree.size(t) == 7

    items = t |> LeftiestTree.to_list() |> Enum.map(& &1.item)
    assert [7, 2, 2, 1, -1, -1, -3] == items
  end
end
