defmodule Catachronon.Mailer do
  @moduledoc """
  Local mail daemon that just takes the Bamboo Mailer wholesale. 
  """
  use Bamboo.Mailer, otp_app: :catachronon
end
