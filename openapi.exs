Application.put_env(:phoenix, :json_library, Jason)
Application.put_env(:oas, Oas.Endpoint,
  http: [
    ip: {127, 0, 0, 1},
    port: String.to_integer(System.get_env("PORT") || "5123"),
  ],
  server: true,
  secret_key_base: :crypto.strong_rand_bytes(32) |> Base.encode16()
)

Mix.install([
  {:plug_cowboy, "~> 2.5"},
  {:open_api_spex, "~> 3.18"},
  {:jason, "~> 1.4"},
  {:phoenix, "~> 1.7"},
  {:phoenix_live_view, "~> 0.18.2"}
])

defmodule Oas.ApiSpec do 
  @moduledoc """
  Responsible for loading and prepping the OpenApi file for serving through a Swagger UI.
  """
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    "./build/smithy/openapi-conversion/openapi/Weather.openapi.json"
    |> File.read!()
    |> Jason.decode!()
    |> OpenApiSpex.OpenApi.Decode.decode()
    |> OpenApiSpex.resolve_schema_modules()
  end
end

defmodule Oas.ErrorView do
  @moduledoc """
  This view does not really serve a purpose, it's just here to make sure Phoenix doesn't throw
  a nasty `ErrorView not defined` error.
  """
  def render(template, _), do: Phoenix.Controller.status_message_from_template(template)
end

defmodule Router do
  use Phoenix.Router

  pipeline :browser do
    plug(:accepts, ["html"])
  end

  pipeline :api do
    plug OpenApiSpex.Plug.PutApiSpec, module: Oas.ApiSpec
  end

  scope "/" do
    pipe_through(:browser)

    # Here the actual UI is served.
    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  scope "/api/openapi" do
    pipe_through(:api)

    # And here we serve the spec as JSON
    forward "/", OpenApiSpex.Plug.RenderSpec, []
  end
end

defmodule Oas.Endpoint do
  use Phoenix.Endpoint, otp_app: :oas
  plug(Router)
end

# Launch missiles?
{:ok, _} = Supervisor.start_link([Oas.Endpoint], strategy: :one_for_one)
Process.sleep(:infinity)
