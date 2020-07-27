defmodule EventBusHandler.Bootstrap do
  # Manages subscriber bootstraping.
  @moduledoc false

  def start_link(module) when is_atom(module) do
    Supervisor.start_link(module, nil, name: module)
  end

  def init(module) when is_atom(module) do
    children = Enum.flat_map(module.handlers(), &module_to_child_specs/1)
    Supervisor.init(children, strategy: :one_for_one)
  end

  defp module_to_child_specs(module) when is_atom(module) do
    supervisor_id = Module.concat(module, EventSupervisor)
    subscription_id = Module.concat(module, SubscriptionTask)

    [
      Supervisor.child_spec(
        {EventBusHandler.EventSupervisor, module},
        id: supervisor_id
      ),
      Supervisor.child_spec(
        {EventBusHandler.SubscriptionTask, module},
        id: subscription_id
      )
    ]
  end
end
