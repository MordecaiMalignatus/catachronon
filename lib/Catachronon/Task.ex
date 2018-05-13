defmodule Catachronon.Task do
  @moduledoc """
  Struct-module for a Task in Catachronon. A task describes a reminder to be
  sent, an email to happen at some point, along with the information
  necessary to deliver that email. Defaults are given in a manner that makes
  it easy to reason about what shape they should have, but `recurring` needs
  some additional explanation. 

  Valid values for :recurring are: 
  - :not_recurring
  - minutes: num
  - hours: num
  - days: num
  - weeks: num
  - months: num
  - years: num
  """
  defstruct body: "",
            title: "",
            to: "",
            from: {"Catachronon", "catachronon@malignat.us"},
            # ISO date format string.
            time: "2050-01-01T00:00:00",
            recurring: :not_recurring
end
