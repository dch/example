use Mix.Config

# use console log and enable syslog via unix domain socket
# handling OTP & SASL reports is noisy in production but it
# ensures we catch failing supervisor trees
config :logger,
  backends: [:console, {LoggerSyslogBackend, :syslog}],
  handle_otp_reports: true,
  handle_sasl_reports: true,
  truncate: 65440,
  utc_log: true

config :logger, :console,
  metadata: :all,
  level: :debug

# app_id is required to correctly tag entries in syslog metadata
# buffer should be slightly bigger than Logger's truncate config
# app_id ensures that syslog entries can be filtered by app name
config :logger, :syslog,
  level: :warn,
  buffer: 65536,
  app_id: :example

# ensure amqp's lager dependency plays nicely with elixir Logger
config :lager,
  error_logger_redirect: false,
  error_logger_whitelist: [Logger.ErrorHandler],
  crash_log: false,
  handlers: [LagerLogger: [level: :warn]]

config :sasl,
  errlog_type: :error,
  sasl_error_logger: false

config :kernel,
  hist: false,
  inet_dist_listen_min: 4370,
  inet_dist_listen_max: 4400

config :os_mon,
  start_memsup: false,
  start_cpu_sup: false,
  start_disksup: false

# katja is a lightweight riemann client in erlang
# ttl is in seconds, names are erlang charlists
config :katja,
  host: 'localhost',
  transport: :tcp,
  port: 5555,
  defaults: [
    host: :vm_name,
    ttl: 30,
    tags: ['example']
  ]

# pass a custom VM name through to riemann for BEAM stats
config :katja_vmstats,
  service: 'example vmstats'
