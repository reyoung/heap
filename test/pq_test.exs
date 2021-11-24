defmodule Heap.PQTest do
  use ExUnit.Case
  doctest Heap.PQ

  alias Heap.PQ

  test "test pq" do
    q = PQ.empty()
    assert PQ.empty?(q)
    q = PQ.enqueue(q, 1)
    assert not PQ.empty?(q)
    {:ok, q, item} = PQ.dequeue(q)
    assert item == 1
    assert PQ.empty?(q)
  end
end
