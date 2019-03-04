defmodule TailPipe do
  @moduledoc """
  An operator macro for piping into the final argument of a function.

  Via the `~>/2` macro, overloads the operator as the "tail pipe". This lets
  you pipe the output of preceding logic set into the final (i.e. tail) argument
  of the next function.

  ### Examples

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

  ### Why?

  Why not!

  But really, this is mostly an experiment. Elixir provides both a set of reserved
  operators that can be overloaded and a macro system to do so. In other functional
  languages, something similar exists in the form of the "backwards pipe" operator.
  The tail pipe is similar, but you call it in the left-to-right order as the pipe
  operator.

  Also, it does feel useful for the small handful of cases where the final
  argument in a function is often the result of a chain (i.e. pipeline) of operations,
  like in the struct example above.
  """

  defmacro __using__(_) do
    quote do
      import TailPipe
    end
  end

  defmacro lhs ~> rhs do
    case rhs do
      {_, _, args} ->
        Macro.pipe(lhs, rhs, length(args))

      _ ->
        raise ArgumentError,
          message:
            "Cannot backwards pipe #{Macro.to_string(lhs)} into #{Macro.to_string(rhs)}. " <>
              "Can only pipe into local calls foo(), remote calls Foo.bar() or " <>
              "anonymous functions calls foo.()"
    end
  end
end
