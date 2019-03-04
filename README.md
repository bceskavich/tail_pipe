# BackPipe

A simple reverse pipe operator for Elixir via the `~>` operator. Lets you pipe the output of preceding logic into the final argument position of the next function.

### Why?

Why not! But really, a few quick reasons:

- Experimentation, and putting one of Elixir's overloadable operators to use
- A reverse pipe operator is not a novel concept. Other functional languages
have them, and this is a study of what it could look like in Elixir.
- It's actually useful for the small handful of cases where the final argument
in a function is often the result of a chain (i.e. pipeline) of operations.
Like in the struct creation example above.

## Docs

TK

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `back_pipe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:back_pipe, "~> 0.1.0"}
  ]
end
```

## Examples

```elixir
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
