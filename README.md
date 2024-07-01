# Single-file Phoenix & Smithy

## Prerequisites

- [smithy-cli](https://smithy.io/2.0/guides/smithy-cli/index.html)
- [Elixir](https://elixir-lang.org/)

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
