use Mix.Config

config :catachronon, Catachronon.Mailer,
  adapter: Bamboo.MailgunAdapter,
  domain: System.get_env("MAILGUN_DOMAIN_NAME"),
  api_key: System.get_env("MAILGUN_API_KEY")

config :catachronon, Catachronon.Scanner,
  watched_dir: File.cwd! <> "/test_tasks/",
  scan_interval: 60 * 1000 # Look at the dir once a minute.
