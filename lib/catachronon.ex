defmodule Catachronon do
  use Application

  def start(_type, _args) do
    IO.puts("starting up")
    Catachronon.Supervisor.start_link([])
  end
end
