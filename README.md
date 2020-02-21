# SpinningSquares

Idea:
* Root supervisor contains DynamicSupervisor and control process for control dom elements
* Control process has two buttons, "Spawn" and "Crash"
* Spawn: Adds a new process in the DynamicSupervisor
* Crash: Crashes itself, hereby also the parent supervisor and the DynamicSupervisor
* Each process in the DynamicSupervisor registers a timer, and updates the style DOM element to rotate a red square (or something)
* There is a separate process that monitors it and makes sure to remove the DOM element for the square if the controlling process goes down (`LinkedElement`)

You still can't really run it, there's still plumbing work to do

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `spinning_squares` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:spinning_squares, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/spinning_squares](https://hexdocs.pm/spinning_squares).

