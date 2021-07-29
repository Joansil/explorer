# Explorer

**Backend challenge**

  Please read the docs inside in the modules. That explain all functions and how use it. 

## Installation
  Please run: 'mix deps.get' to install all dependecies and 'mix.credo'
  
  Run using IEX: 'iex -S mix'
  
  And pass the datas asked in the challenge, to the function 'Explorer.many_spcrafts'
  
  iex> Explorer.many_spcrafts([["5", "5"], ["1", "2", "N"], ["LMLMLMLMM"], ["3", "3", "E"], ["MMRMMRMRRM"]]) 
  
  and you have the expected out
  
  ["1 3 N", "5 1 E"]

  Please, run 'mix test' to run all tests.


If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `explorer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:explorer, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/explorer](https://hexdocs.pm/explorer).

