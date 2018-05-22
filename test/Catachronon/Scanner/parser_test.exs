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

  describe "End-to-End parsing of whole files" do
    test "Should parse a file with interspersed body lines correctly." do
      res = Parser.parse_file "- Title: Hi!\nThis is\n- To: hello@test.com\nSome Body Once Told Me"
      expected = %Catachronon.Task{
        body: "This is\nSome Body Once Told Me",
        title: "Hi!",
        to: "hello@test.com", 
        from: {"Catachronon", "catachronon@malignat.us"},
        time: "2050-01-01T00:00:00",
        recurring: :not_recurring
      }

      assert res === expected
    end
  end
end
