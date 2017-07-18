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

  def connect(_) do
    {:error, "Node must be an Atom or String."}
  end

  @doc """
  Sends a message to a node by shortened name.

  Can take a full name (e.g. "dude@pc") or shortened (e.g. "dude")
  """
  def send_message(node, message) when is_binary(message) do
    Router.send_message(node, message)
  end

  def send_message(_, _) do
    {:error, "Message must be a String."}
  end

  @doc """
  Sends a message to all connected Nodes.
  """
  def broadcast_message(message) when is_binary(message) do
    Router.broadcast_message(message)
  end

  def broadcast_message(_) do
    {:error, "Message must be a String."}
  end
end
