defmodule SpinningSquares do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args)
  end

  @impl true
  def init(_args) do
    {:ok, document} = Lumen.Web.Document.new()
    {:ok, root} = Lumen.Web.Document.get_element_by_id(document)

    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: SpinningSquares.SquareSupervisor},
      {SpinningSquares.ControlGui, {document, root}},
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

end
