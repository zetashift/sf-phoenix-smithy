# Single-file Phoenix & Smithy

## Prerequisites

- [https://smithy.io/2.0/guides/smithy-cli/index.html](smithy-cli)
- [https://elixir-lang.org/](Elixir)

The included Nix flake also adds in all the prerequisites.

## Commands

### Build the OpenAPI spec

```sh
 smithy-cli build
```

### Serve it!

```sh
elixir openapi.exs
```

You should then be able to visit the SwaggerUI on: `http://localhost:5123/swaggerui`
