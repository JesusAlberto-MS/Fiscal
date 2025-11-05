import Config

config :fiscal,
  env: config_env()

# Import environment-specific configuration
import_config "#{config_env()}.exs"
