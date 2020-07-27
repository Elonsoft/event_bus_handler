defmodule EventBusHandler.EventSupervisor do
  # Manages supervision of user callbacks.

  # Incapsulates logic of registering a dynamic supervisor for a handler
  # and starting a task under the supervisor.
  @moduledoc false

  use DynamicSupervisor

  def start_link(module) when is_atom(module) do
    name = Module.concat(module, EventSupervisor)
    DynamicSupervisor.start_link(__MODULE__, nil, name: name)
  end

  def init(nil) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_task(module, fun) do
    event_supervisor = Module.concat(module, EventSupervisor)
    DynamicSupervisor.start_child(event_supervisor, {Task, fun})
  end
end
