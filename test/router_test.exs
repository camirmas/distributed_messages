defmodule RouterTest do
  use ExUnit.Case

  alias DistributedMessages.{Server, Router}

  test "it starts up" do
    assert Process.whereis Router
  end

  test "it sends messages" do
    assert :ok = Router.send_message(Kernel.node, "hello")
  end
end
