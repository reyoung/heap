defmodule Heap.LeftiestTree do
  @moduledoc """
  A leftiest tree/heap implemtation with customizable priority and any type of item.

  This tree always enforces the smallest priority at the top node, and the left path of tree is higher than right.
  See https://en.wikipedia.org/wiki/Leftist_tree for algorithm details.

  """

  @enforce_keys [:priority, :item]

  defstruct left: nil, right: nil, priority: nil, item: :empty_tree, s_value: 1

  @doc """
  Returns a single node leftiest tree, with item and priority.

  ## Examples

      iex> Heap.LeftiestTree.single(1, 1)
      ...>   |> Heap.LeftiestTree.size
      1
  """
  @spec single(any, any) :: %Heap.LeftiestTree{
          item: any,
          left: nil,
          priority: any,
          right: nil,
          s_value: 1
        }
  def single(item, priority) do
    %Heap.LeftiestTree{priority: priority, item: item}
  end

  @doc """
  Returns a single node leftest tree, with item and use  this item as priority.

  ## Examples

      iex>  Heap.LeftiestTree.single(1)
      ...>    |>  Heap.LeftiestTree.size
      1
  """
  @spec single(any) :: %Heap.LeftiestTree{
          item: any,
          left: nil,
          priority: any,
          right: nil,
          s_value: 1
        }
  def single(item) do
    single(item, item)
  end

  @doc """
  Returns true if the leftest tree is empty.

  NOTE: the nil is an empty leftest tree also.

  ## Examples

      iex>  Heap.LeftiestTree.single(1)
      ...>    |>  Heap.LeftiestTree.empty?
      false
  """
  @spec empty?(atom | %{:item => any, optional(any) => any}) :: boolean
  def empty?(nil) do
    true
  end

  def empty?(tree) do
    tree.item == :empty_tree
  end

  @doc """
  Returns the top node of tree. If the tree is empty, returns {:error, "empty tree"}, otherwise returns {:ok, %{priority: ..., item: ...}}

  ## Examples

      iex> Heap.LeftiestTree.single(1)
      ...>   |> Heap.LeftiestTree.top
      {:ok, %{priority: 1, item: 1}}

      iex> Heap.LeftiestTree.single(1)
      ...>   |> Heap.LeftiestTree.pop
      ...>   |> Heap.LeftiestTree.top
      {:error, "empty tree"}
  """
  def top(tree) do
    cond do
      empty?(tree) -> {:error, "empty tree"}
      true -> {:ok, %{priority: tree.priority, item: tree.item}}
    end
  end

  @doc """
  Removes the topest node of tree, rebalances the tree, and returns. Do nothing if tree is empty.

  ## Examples

      iex> Heap.LeftiestTree.single(1)
      ...>   |> Heap.LeftiestTree.pop
      ...>   |> Heap.LeftiestTree.empty?
      true

      iex> Heap.LeftiestTree.single(1)
      ...>   |> Heap.LeftiestTree.pop
      ...>   |> Heap.LeftiestTree.pop
      nil
  """
  def pop(tree) do
    cond do
      empty?(tree) -> nil
      true -> merge(tree.left, tree.right)
    end
  end

  @doc """
  Merges two leftiest trees into a leftiest tree.

  ## Examples

      iex> nil
      ...>  |> Heap.LeftiestTree.merge(Heap.LeftiestTree.single(1))
      ...>  |> Heap.LeftiestTree.merge(nil)
      ...>  |> Heap.LeftiestTree.merge(Heap.LeftiestTree.single(-1))
      ...>  |> Heap.LeftiestTree.to_list
      [%{item: 1, priority: 1}, %{item: -1, priority: -1}]
  """
  def merge(tree1, tree2) do
    cond do
      empty?(tree1) ->
        tree2

      empty?(tree2) ->
        tree1

      tree1.priority > tree2.priority ->
        merge_impl(tree2, tree1)

      true ->
        merge_impl(tree1, tree2)
    end
  end

  @doc """
  Returns the number of elements in tree.

  ## Examples

      iex> nil |> Heap.LeftiestTree.size
      0

      iex> Heap.LeftiestTree.single(1) |> Heap.LeftiestTree.size
      1
  """
  def size(tree) do
    size_impl(tree, 0)
  end

  defp size_impl(tree, acc) do
    cond do
      empty?(tree) -> acc
      # tail call optimization for left or right is empty
      empty?(tree.left) -> size_impl(tree.right, acc + 1)
      empty?(tree.right) -> size_impl(tree.left, acc + 1)
      # general situation.
      # it could cause stack overflow if the right tree is too deep.
      true -> size_impl(tree.left, size_impl(tree.right, acc + 1))
    end
  end

  defp merge_impl(tree1, tree2) do
    merged_tree = merge(tree1.right, tree2)

    cond do
      tree1.left == nil ->
        %Heap.LeftiestTree{
          left: merged_tree,
          right: nil,
          priority: tree1.priority,
          item: tree1.item,
          s_value: 1
        }

      # always make the left tree's s_value is larger than right tree.
      # the returned tree's s_value = the returned tree.right.s_value + 1
      tree1.left.s_value < merged_tree.s_value ->
        %Heap.LeftiestTree{
          left: merged_tree,
          right: tree1.left,
          priority: tree1.priority,
          item: tree1.item,
          s_value: tree1.left.s_value + 1
        }

      true ->
        %Heap.LeftiestTree{
          left: tree1.left,
          right: merged_tree,
          priority: tree1.priority,
          item: tree1.item,
          s_value: merged_tree.s_value + 1
        }
    end
  end

  @doc """
  Returns the list of %{priority: ..., item:, ...} ordered by priority descendingly.

  ## Examples

      iex> Heap.LeftiestTree.single(-10)
      ...>  |> Heap.LeftiestTree.merge(Heap.LeftiestTree.single(1))
      ...>  |> Heap.LeftiestTree.merge(Heap.LeftiestTree.single(3))
      ...>  |> Heap.LeftiestTree.merge(Heap.LeftiestTree.single(-1))
      ...>  |> Heap.LeftiestTree.to_list
      [%{item: 3, priority: 3}, %{item: 1, priority: 1}, %{item: -1, priority: -1}, %{item: -10, priority: -10}]]
  """
  def to_list(tree) do
    to_list_impl(tree, [])
  end

  defp to_list_impl(tree, acc) do
    case top(tree) do
      {:error, _} ->
        acc

      {:ok, top_elem} ->
        sub_tree = merge(tree.left, tree.right)
        to_list_impl(sub_tree, [top_elem | acc])
    end
  end
end
