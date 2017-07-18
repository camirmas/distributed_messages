defmodule RouterTest do
  use ExUnit.Case

  alias DistributedMessages.Router

  test "it starts up" do
    assert Process.whereis Router
  end

  describe "failing to connect to other nodes" do
    test "it returns an error message" do
      assert {:error, "Node not found."} = Router.connect(:stuff)
    end
  end

  describe "connecting to other nodes successfully" do
    @tag :distributed
    test "it returns :ok" do
      node = Application.get_env(:distributed_messages, :start_node)
      assert :ok = Router.connect(node)
    end
  end

  describe "sending messages" do
    @tag :distributed
    test "sends a message to a given node" do
      node = Application.get_env(:distributed_messages, :start_node)
      Router.connect(node)

      assert :ok = Router.send_message(node, "hello")
    end

    @tag :distributed
    test "sends a message to a given node with abbreviated name" do
      node = Application.get_env(:distributed_messages, :start_node)
      Router.connect(node)

      assert :ok = DistributedMessages.send_message("test", "hello")
    end

    test "cannot send a message to a nonexistent node" do
      assert {:error, "Node not found."} = Router.send_message("wrong", "hello")
    end
  end

  describe "broadcasting messages" do
    @tag :distributed
    test "sends to all connected Nodes" do
      node = Application.get_env(:distributed_messages, :start_node)
      Router.connect(node)

      assert [:ok] = Router.broadcast_message("hello")
    end
  end
end
