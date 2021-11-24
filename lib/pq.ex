defmodule Heap.PQ do
  @moduledoc """
  A proirity queue implemetation.

  The priority of each elements can be customized when `enqueue`.
  """

  defstruct tree: nil
  alias Heap.LeftiestTree

  @doc """
  Returns an empty priority queue.

  ## Examples

      iex> Heap.PQ.empty() |> Heap.PQ.empty?()
      true
  """
  def empty() do
    new()
  end

  defp new(t \\ nil) do
    %Heap.PQ{tree: t}
  end

  @doc """
  Enqueue an item into queue with optional priority. If priority is not set, the item itself is considered as the priority.

  Returns a new queue with item enqueued.

  ## Examples
      iex> {:ok, q, item} = Heap.PQ.empty() |> Heap.PQ.enqueue(1, -1) |> Heap.PQ.enqueue(3, -3) |> Heap.PQ.enqueue(-3, 3) |> Heap.PQ.dequeue()
      iex> item
      3
  """
  def enqueue(pq, item, priority \\ nil) do
    new(
      LeftiestTree.merge(
        pq.tree,
        LeftiestTree.single(
          item,
          if priority != nil do
            priority
          else
            item
          end
        )
      )
    )
  end

  @doc """
  Dequeue and pick the smallest priority item.

  If everything is ok, it returns {:ok, new_queue, picked_item}, otherwise it returns {:error, reason}.

  ## Examples

      iex> {:ok, q, item} = Heap.PQ.empty() |> Heap.PQ.enqueue(1, -1) |> Heap.PQ.enqueue(3, -3) |> Heap.PQ.enqueue(-3, 3) |> Heap.PQ.dequeue()
      iex> item
      3
  """
  def dequeue(pq) do
    case LeftiestTree.top(pq.tree) do
      {:error, reason} -> {:error, reason}
      {:ok, top_elem} -> {:ok, new(LeftiestTree.pop(pq.tree)), top_elem.item}
    end
  end

  @doc """
  Returns whether the queue is empty.
  """
  def empty?(pq) do
    LeftiestTree.empty?(pq.tree)
  end
end
