# Builds the Smithy files to an OpenAPI spec.
build:
    cs launch --contrib smithy-cli -- build
# Run the Phoenix server that will serve the Swagger UI.
serve:
    elixir openapi.exs

