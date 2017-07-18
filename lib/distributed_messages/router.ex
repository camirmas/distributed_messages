defmodule DistributedMessages.Router do
  @moduledoc """
  Responsible for routing message requests to specific clients.
  """
  use GenServer

  # API

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Connects to a given Node.
  """
  def connect(node) do
    GenServer.call(__MODULE__, {:connect, node})
  end

  @doc """
  Sends a message to a given Node.
  """
  def send_message(node, message) do
    case node = find_node(node) do
      :no_node ->
        not_found_error()
      _ ->
        GenServer.cast({__MODULE__, node}, {:send_message, Node.self, message})
    end
  end

  @doc """
  Sends a message to all connected Nodes.
  """
  def broadcast_message(message) do
    Node.list
    |> Enum.map(&(send_message(&1, message)))
  end

  # Callbacks

  def handle_call({:connect, node}, _from, state) do
    case Node.connect(node) do
      true ->
        {:reply, :ok, state}
      _ ->
        {:reply, not_found_error(), state}
    end
  end

  def handle_cast({:send_message, from_node, message}, state) do
    name = shorten_node(from_node)
    IO.puts "\n#{name}: #{message}"

    {:noreply, state}
  end

  # Private

  defp find_node(node) when is_atom(node) do
    node
    |> Atom.to_string
    |> find_node
  end

  defp find_node(node) when is_binary(node) do
    Node.list
    |> Enum.find(:no_node, fn list_node ->
      list_node = Atom.to_string(list_node)
      (node == list_node) ||
      (node == shorten_node(list_node))
    end)
  end

  defp shorten_node(node) when is_atom(node) do
    node
    |> Atom.to_string
    |> shorten_node
  end

  defp shorten_node(node) when is_binary(node) do
    node
    |> String.split("@")
    |> List.first
  end

  defp not_found_error do
    {:error, "Node not found."}
  end
end
