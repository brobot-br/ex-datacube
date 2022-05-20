import Config

config :ex_datacube, auth_token: nil

config :ex_datacube, ExDatacube.Veiculos,
  auth_token: nil,
  adaptador: ExDatacube.Veiculos.Adaptores.Default
