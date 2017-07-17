# Distributed Messages

> :love_letter: Learning about distributed messaging in Elixir

## Getting started

- `git clone git@github.com:camirmas/distributed_messages.git`
- `cd distributed_messages`

### Terminal

- In one terminal window, `iex --sname [your_name] -S mix`. This will create a node whose name takes the form `your_name@hostname`, e.g. `cam@cam-pc`.
- In another terminal window, `iex --sname [different_name] -S mix`. This will create another node.
- `DistributedMessages.connect("name@hostname")`, specifying the node in the other terminal window.
- `DistributedMessages.send_message("different_name", "hello friend")`. You do not need to specify the entire node name, just whatever comes before the `@`.

### Separate Machines

The main difference here is that you need to use your ip address when starting up the app. A quick `ifconfig` should do the trick.

- On one machine, `iex --name [name@ip_address] -S mix`.
- On another machine, `iex --name [another_name@ip_address] -S mix`.
- `DistributedMessages.connect("name@ip_address")`, specifying the node on the other machine.
- `DistributedMessages.send_message("different_name", "hello friend")`. You do not need to specify the entire node name, just whatever comes before the `@`.

## Running the Tests

`mix test` will only run non-distributed tests. In order to run the full test suite, you'll need to start up an app with `iex --sname test -S mix` in one
terminal window, and `elixir --sname [name] -S mix test` in another.
