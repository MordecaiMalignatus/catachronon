defmodule Catachronon.Notifier do
  @moduledoc """
  Simple mail daemon using Bamboo to actually notify me of things. This ends up
  sending the emails.
  """
  import Bamboo.Email

  def send_email(subject, body, target) do
    new_email
    |> to(target)
    |> from("catachronon@malignat.us")
    |> subject(subject)
    |> text_body(body)
    |> Catachronon.Mailer.deliver_later()
  end
end
