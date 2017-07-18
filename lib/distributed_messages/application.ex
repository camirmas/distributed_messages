defmodule DistributedMessages.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    set_cookie()

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: DistributedMessages.Worker.start_link(arg1, arg2, arg3)
      worker(DistributedMessages.Router, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DistributedMessages.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Don't attempt to set cookie if no Node.
  defp set_cookie do
    case Node.self do
      :"nonode@nohost" ->
        nil
      _ ->
        Application.get_env(:distributed_messages, :cookie)
        |> Node.set_cookie
    end
  end
end
