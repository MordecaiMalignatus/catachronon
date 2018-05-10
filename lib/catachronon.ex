defmodule Catachronon do
  @moduledoc """
  Main Entry point for Catachronon. This spawns the trees for Notifier,
  Scheduler and the Scanner.
  """
  use Application

  def start(_type, _args) do
    Catachronon.Supervisor.start_link([])
  end
end
