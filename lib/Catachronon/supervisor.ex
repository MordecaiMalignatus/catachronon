defmodule Catachronon.Supervisor do
  @moduledoc """
  This coordinates Notifier, Scheduler and Scanner, and keeps it all alive and
  well. 
  """
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      # None so far :D
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
