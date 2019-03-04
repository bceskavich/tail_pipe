defmodule BackPipe do
  @moduledoc """
  A simple reverse pipe operator for Elixir via the `~>` operator.

  Via the `~>/2` macro, overloads the operator as the reverse pipe. This lets
  you pipe the output of preceding logic into the final argument position of
  the next function.

  ### Examples

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

  ### Why?

  Why not! A few actual reasons:

  - Experimentation, and putting one of Elixir's overloadable operators to use
  - A reverse pipe operator is not a novel concept. Other functional languages
  have them, and this is a study of what it could look like in Elixir.
  - It's actually useful for the small handful of cases where the final argument
  in a function is often the result of a chain (i.e. pipeline) of operations.
  Like in the struct creation example above.
  """

  defmacro __using__(_) do
    quote do
      import BackPipe
    end
  end

  defmacro lhs ~> rhs do
    case rhs do
      {_, _, args} ->
        Macro.pipe(lhs, rhs, length(args))

      _ ->
        raise ArgumentError,
          message:
            "Cannot reverse pipe #{Macro.to_string(lhs)} into #{Macro.to_string(rhs)}. " <>
              "Can only pipe into local calls foo(), remote calls Foo.bar() or " <>
              "anonymous functions calls foo.()"
    end
  end
end
