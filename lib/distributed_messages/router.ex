defmodule DistributedMessages.Router do
  @moduledoc """
  Responsible for routing message requests to specific clients.
  """
  use GenServer

  alias DistributedMessages.Server

  # API
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def connect(node) do
    GenServer.call(__MODULE__, {:connect, node})
  end

  def send_message(node, message) do
    GenServer.call({__MODULE__, node}, {:send_message, message})
  end

  # Callbacks

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:connect, node}, _from, state) do
    case Node.connect(node) do
      :ignored ->
        {:reply, {:error, "Node not found."}, state}
      _ ->
        {:reply, :ok, state}
    end
  end

  def handle_call({:send_message, message}, _from, state) do
    IO.puts message

    {:reply, :ok, state}
  end
end
