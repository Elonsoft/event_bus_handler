defmodule EventBusHandler.SubscriptionTask do
  # OTP task that manages subscription to an event.
  @moduledoc false

  use Task, restart: :transient

  def start_link(module) when is_atom(module) do
    Task.start_link(__MODULE__, :subscribe, [module])
  end

  def subscribe(module) when is_atom(module) do
    EventBus.subscribe({module, module.topics()})
  end
end
