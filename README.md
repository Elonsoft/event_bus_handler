# EventBusHandler

Elixir EventBus helper that manages event handler supervision.

## Installation

The package can be installed by adding `event_bus_handler` to your
list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:event_bus_handler, "~> 0.1.0"}
  ]
end
```

Documentation on [HexDocs](https://hexdocs.pm/event_bus_handler).

## Usage

You just need to define a subscription handler module:

```elixir
      defmodule MyApp.SomeEventHandler do
        use EventBusHandler, topics: ["some_topic_*"]
        # with :topics key you specify topics to which the handler will be
        # subscribed, i.e. to every topic, starting with "some_topic_".
        alias EventBus.Model.Event

        def handle(:some_topic_1, %Event{data: data} = event) do
          # Here goes your handling of an event on topic :your_topic_1
          # If you for some reason want to skip handling (i.e. mark the event as
          # skipped), return `:skip` or something. Then warning will appear that
          # an event with this topic was skipped, and the returned tag will be
          # shown. Otherwise, just return `:ok`.

          :ok
        end
      end
```

Create a config module and start it from your application:

```elixir
      defmodule MyApp.EventBusHandler do
        use EventBusHandler, handlers: [YourEventHandler]
      end

      # ...
      def start(_type, _args) do
        children = [
          Florissimo.Repo,
          FlorissimoWeb.Endpoint,
          # In the code below, in key :handlers you specify all defined event
          # handlers.
          EventBusHandler
        ]
      #  ...
```

All the tasks will be started in its own process under a supervisor.
For every handler module separate supervisor is created.
