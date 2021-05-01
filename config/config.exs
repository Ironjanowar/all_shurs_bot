# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :all_shurs_bot, AllShursBot.Repo,
  database: "all_shurs_bot_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :all_shurs_bot,
  ecto_repos: [AllShursBot.Repo]

config :ex_gram,
  token: {:system, "BOT_TOKEN"}

config :logger,
  level: :debug,
  truncate: :infinity,
  backends: [{LoggerFileBackend, :debug}, {LoggerFileBackend, :error}]

config :logger, :debug,
  path: "log/debug.log",
  level: :debug,
  format: "$dateT$timeZ [$level] $message\n"

config :logger, :error,
  path: "log/error.log",
  level: :error,
  format: "$dateT$timeZ [$level] $message\n"
