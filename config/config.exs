import Config

config :fiscal,
  env: config_env()

# Configuración del cliente HTTP
config :fiscal, Fiscal.Http, client: Fiscal.Http.HttpClient

# Credenciales de la API
config :fiscal,
  api_key: System.get_env("FISCAL_API_KEY_TEST"),
  tenant_key: System.get_env("FISCAL_TENANT_KEY_TEST"),
  base_url: System.get_env("FISCAL_ULR_TEST")

if config_env() == :test do
  # Import environment-specific configuration
  import_config "#{config_env()}.exs"
end
