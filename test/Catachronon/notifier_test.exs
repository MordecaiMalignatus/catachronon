defmodule Catachronon.NotifierTest do
  alias Catachronon.Notifier
  use ExUnit.Case
  doctest Notifier

  test "Simple emails being created correctly" do
    email =
      Notifier.make_email(
        "This is a test header",
        "this is a test body",
        "test@malignat.us"
      )

    assert email.from == {"Catachronon", "catachronon@malignat.us"}
  end
end
