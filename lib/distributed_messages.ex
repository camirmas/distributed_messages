defmodule DistributedMessages do
  @moduledoc """
  DistributedMessages
  """

  alias DistributedMessages.Router

  @doc """
  Connects the current Node and assigns a
  name.
  """
  def connect do
    Application.get_env(:distributed_messages, :start_node) |> Router.connect()
  end

  def connect(node) when is_binary(node) do
    node
    |> String.to_atom
    |> connect
  end

  def connect(node) when is_atom(node) do
    Router.connect(node)
  end

  @doc """
  Sends a message to a node by shortened name.

  Can take a full name (e.g. "dude@pc") or shortened (e.g. "dude")
  """
  def send_message(node, message) do
    Router.send_message(node, message)
  end
end
