# TailPipe

A simple backwards pipe operator for Elixir via the `~>` operator. Lets you pipe the output of preceding logic into the final argument position of the next function.

### Why?

Why not!

But really, this is mostly an experiment. Elixir provides both a set of reserved operators that can be overloaded and a macro system to do so. In other functional languages, something similar exists in the form of the "backwards pipe" operator. The tail pipe is similar, but you call it in the left-to-right order as the pipe operator.

Also, it does feel useful for the small handful of cases where the final argument in a function is often the result of a chain (i.e. pipeline) of operations, like when calling `struct/2` to dynamically generating new structs.

## Docs

On [Hexdocs](https://hexdocs.pm/tail_pipe/TailPipe.html)

## Installation

Add `tail_pipe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tail_pipe, "~> 0.1.0"}
  ]
end
```

## Examples

```elixir
# Import the operator into your module
import TailPipe

# Calling `use` will work too if you want
use TailPipe

# Basic usage
iex> "hello world" ~> String.split()
["hello", "world"]

# We can chain too
"hello world"
~> String.split()
~> Enum.concat(["oh"])
|> Enum.join(" ")
# "oh hello world"

# More useful: dynamically creating a struct
defmodule Traveler do
  defstruct [:id, :name, :location]

  def new(kwl) do
    kwl
    |> Map.new()
    |> Map.put(:location, "Unknown")
    ~> struct(__MODULE__)
  end
end

iex> Traveler.new(id: 1, name: "Hal")
%Traveler{id: 1, location: "Unknown", name: "Hal"}
```
