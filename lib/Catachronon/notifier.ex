defmodule Catachronon.Notifier do
  @moduledoc """
  Simple mail daemon using Bamboo to actually notify me of things. This ends up
  sending the emails.
  """
  alias Bamboo.Email

  @doc """
  Creates new email struct and fills in the "from" field. 
  """
  def send_email(subject, body, target) do
    Email.new_email()
    |> Email.to(target)
    |> Email.from({"Catachronon", "catachronon@malignat.us"})
    |> Email.subject(subject)
    |> Email.text_body(body)
  end

  @doc """
  Creates email and immediately send it. 
  """
  def send_email!(subject, body, target) do
    mail = send_email(subject, body, target)
    Catachronon.Mailer.deliver_later(mail)
  end
end
