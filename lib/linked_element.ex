defmodule LinkedElement do

  def link_element(element) do
    pid = get_or_spawn()
    send(pid, {:link_element, element})
    :ok
  end

  defp get_or_spawn() do
    case :erlang.get(:linked_element_process) do
      :undefined ->
        pid = spawn_process(self())
        :erlang.put(:linked_element_process, pid)
        pid
      pid ->
        pid
    end
  end

  defp spawn_process(to_monitor) do
    spawn(__MODULE__, :monitor_fun, [to_monitor])
  end

  def monitor_fun(to_monitor) do
    :erlang.monitor(:process, to_monitor)
    monitor_loop([])
  end

  defp monitor_loop(elements) do
    receive do
      {:link_element, element} ->
        [element | elements]
      {:DOWN, _, _, _, _} ->
        delete_elements(elements)
    end
  end

  defp delete_elements([]), do: :ok
  defp delete_elements([element | tail]) do
    Lumen.Web.Element.remove(element)
    delete_elements(tail)
  end

end
