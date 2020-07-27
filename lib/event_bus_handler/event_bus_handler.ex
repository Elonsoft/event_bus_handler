defmodule EventBusHandler do
  @moduledoc """
  Handles `:event_bus` subscriptions.

  You just need to define a subscription handler module:

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

  Create a config module and start it from your application:

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

  All the tasks will be started in its own process under a supervisor.
  For every handler module separate supervisor is created.
  """

  defmacro __using__(handlers: handlers) do
    quote do
      use Supervisor

      def handlers do
        unquote(handlers)
      end

      def start_link(_) do
        EventBusHandler.Bootstrap.start_link(__MODULE__)
      end

      @impl Supervisor
      def init(nil) do
        EventBusHandler.Bootstrap.init(__MODULE__)
      end
    end
  end

  defmacro __using__(topics: topics) do
    quote do
      @behaviour EventBusHandler

      def topics do
        unquote(topics)
      end

      def process(shadow) do
        {:ok, _} =
          EventBusHandler.EventSupervisor.start_task(__MODULE__, fn ->
            EventBusHandler.Dispatcher.dispatch_event(__MODULE__, shadow)
          end)

        :ok
      end
    end
  end

  @type topic :: atom
  @type event :: EventBus.Model.Event.t()
  @type error_reason :: any

  @doc """
  Event handler for the topic
  """
  @callback handle(topic, event) :: :ok | error_reason
end
