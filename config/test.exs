import Config

# Configuración del cliente HTTP para tests
config :fiscal, Fiscal.Http, client: Fiscal.Http.MemoryClient
