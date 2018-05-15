defmodule Catachronon.Scanner.ParserTest do
  alias Catachronon.Scanner.Parser
  use ExUnit.Case
  doctest Parser

  describe "Joining lines" do
    test "Should throw exceptions on duplicate keys" do
      data = [{:title, "Foo"}, {:title, "Bar"}]
      assert_raise(RuntimeError, fn -> Parser.join_body_lines(data, %{}) end)
    end
  end
end
