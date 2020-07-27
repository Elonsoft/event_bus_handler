defmodule EventBusHandler.Dispatcher do
  # Encapsulates callback dispatching logic.
  @moduledoc false

  require Logger

  def dispatch_event(module, shadow) do
    case apply(module, :handle, [topic_name(shadow), fetch_event(shadow)]) do
      :ok ->
        mark_as_completed(module, shadow)

      tag ->
        Logger.warn("Event #{inspect(shadow)} was skipped by #{module} with #{inspect(tag)}")
        mark_as_skipped(module, shadow)
    end
  end

  defp topic_name({_, topic, _}), do: topic
  defp topic_name({topic, _}), do: topic

  defp fetch_event({_, topic, id}) do
    EventBus.fetch_event({topic, id})
  end

  defp fetch_event({_topic, _id} = shadow) do
    EventBus.fetch_event(shadow)
  end

  defp mark_as_completed(module, {config, topic, id}) do
    EventBus.mark_as_completed({{module, config}, topic, id})
  end

  defp mark_as_completed(module, {topic, id}) do
    EventBus.mark_as_completed({module, topic, id})
  end

  defp mark_as_skipped(module, {config, topic, id}) do
    EventBus.mark_as_skipped({{module, config}, topic, id})
  end

  defp mark_as_skipped(module, {topic, id}) do
    EventBus.mark_as_skipped({module, topic, id})
  end
end
