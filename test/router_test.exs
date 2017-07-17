defmodule RouterTest do
  use ExUnit.Case

  alias DistributedMessages.Router

  test "it starts up" do
    assert Process.whereis Router
  end

  describe "when it fails to connect to other nodes" do
    test "it returns an error message" do
      assert {:error, "Node not found."} = Router.connect(:stuff)
    end
  end

  describe "when it connects to other nodes successfully" do
    @tag :distributed
    test "it returns :ok" do
      assert :ok = Router.connect(Kernel.node)
    end
  end
end
