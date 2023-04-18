# ThumbHash

An Elixir bridge to the Rust ThumbHash library.
See: https://github.com/evanw/thumbhash for original implmentation.

## Installation

Note: a Rust toolchain is required to compile rust deps.

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `thumb_hash` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:thumb_hash, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/thumb_hash>.

## Usage

```elixir
ThumbHash.generate_base64_hash!("my-image.jpg")
```
