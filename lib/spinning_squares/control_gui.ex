defmodule SpinningSquares.ControlGui do
  use GenServer

  @impl true
  def init({document, root}) do
    {:ok, control_root} = Lumen.Web.Document.create_element(document, "div")
    :ok = Lumen.Web.Element.set_attribute(control_root, "class", "control-root")
    :ok = Lumen.Web.Node.append_child(root, control_root)
    :ok = LinkedElement.link_element(control_root)

    {:ok, crash_button} = Lumen.Web.Document.create_element(document, "p")
    :ok = Lumen.Web.Window.add_event_listener(crash_button, :onclick, SpinningSquares.ControlGui, :crash_button_event)
    :ok = Lumen.Web.Node.append_child(control_root, crash_button)
    {:ok, crash_text} = Lumen.Web.Document.create_text_node(document, "Crash!")
    :ok = Lumen.Web.Node.append_child(crash_button, crash_text)

    {:ok, %{
      root: root,
      control_root: control_root,
    }}
  end

  def crash_button_event() do
    :lumen_intrinsics.println("yay click crash")
  end

end
