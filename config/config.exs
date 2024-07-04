# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :parcel_manager,
  ecto_repos: [ParcelManager.Infrastructure.Persistence.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :parcel_manager, ParcelManagerWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: ParcelManagerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ParcelManager.PubSub,
  live_view: [signing_salt: "Z8np3nY+"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :parcel_manager, ParcelManager.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

# Configures Oban
config :parcel_manager, Oban,
  engine: Oban.Engines.Basic,
  queues: [emails: 10],
  repo: ParcelManager.Infrastructure.Persistence.Repo,
  plugins: [
    {Oban.Plugins.Lifeline, rescue_after: :timer.minutes(30)}
  ]
