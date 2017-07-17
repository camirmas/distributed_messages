defmodule DistributedMessagesTest do
  use ExUnit.Case

  @tag :distributed
  test "it connects to a node" do
    assert :ok = DistributedMessages.connect

    assert length(Node.list) == 1
  end

  @tag :distributed
  test "it connects to a node by binary name" do
    node =
      Application.get_env(:distributed_messages, :start_node)
      |> Atom.to_string
    assert :ok = DistributedMessages.connect(node)

    assert length(Node.list) == 1
  end

  @tag :distributed
  test "it connects to a node by atom name" do
    node = Application.get_env(:distributed_messages, :start_node)
    assert :ok = DistributedMessages.connect(node)

    assert length(Node.list) == 1
  end

  @tag :distributed
  test "sends a message to a given node" do
    DistributedMessages.connect
    [node] = Node.list

    assert :ok = DistributedMessages.send_message(node, "hello")
  end

  @tag :distributed
  test "sends a message to a given node with abbreviated name" do
    DistributedMessages.connect

    assert :ok = DistributedMessages.send_message("test", "hello")
  end

  test "sends a message to a nonexistent node" do
    assert {:error, "Node not found."} = DistributedMessages.send_message("wrong", "hello")
  end
end
