defmodule DistributedMessagesTest do
  use ExUnit.Case

  describe "connecting to a node" do
    @tag :distributed
    test "connects automatically" do
      assert :ok = DistributedMessages.connect

      assert length(Node.list) == 1
    end

    @tag :distributed
    test "connects by binary name" do
      node =
        Application.get_env(:distributed_messages, :start_node)
        |> Atom.to_string
      assert :ok = DistributedMessages.connect(node)

      assert length(Node.list) == 1
    end

    @tag :distributed
    test "connects by atom name" do
      node = Application.get_env(:distributed_messages, :start_node)
      assert :ok = DistributedMessages.connect(node)

      assert length(Node.list) == 1
    end

    test "cannot connect by other means" do
      assert {:error, "Node must be an Atom or String."} = DistributedMessages.connect({})
    end
  end

  describe "sending messages" do
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

    test "cannot send a message to a nonexistent node" do
      assert {:error, "Node not found."} = DistributedMessages.send_message("wrong", "hello")
    end

    test "cannot send a message that isn't a String." do
      DistributedMessages.connect

      assert {:error, "Message must be a String."} = DistributedMessages.send_message("test", [])
    end
  end

  describe "broadcasting messages" do
    @tag :distributed
    test "sends to all connected Nodes" do
      DistributedMessages.connect

      assert [:ok] = DistributedMessages.broadcast_message("hello")
    end

    test "cannot broadcast a message that isn't a String" do
      assert {:error, "Message must be a String."} = DistributedMessages.broadcast_message([])
    end
  end
end
