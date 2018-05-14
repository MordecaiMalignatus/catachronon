defmodule Catachronon.Scanner.Parser do
  @moduledoc """
  This is the module responsible for parsing my reminders and recurring things
  files. It's a pretty simple file format: 

  - One KV-pair per line, 
  - Keys start with "- $key" in a yaml-like format
  - Special keys determine end result
  - Rest is just a flat file. 
  - "Body" lines get joined. 

  List of special keys: 

  - recurring: $number $interval
  - to: $email
  - title: $string
  - due: $timestamp
  """

  @doc """
  Parses a file into a Task. This is responsible for turning Files into things
  Catachronon can work with.

  ## Examples: 

  iex> Parser.parse_file "- Title: Hi!\\nThis is\\n- Target: hello@test.com\\nSome Body Once Told Me"
  %Catachronon.Task{
    body: "This is\\nSome Body Once Told Me",
    title: "Hi!",
    to: "hello@test.com", 
    from: {"Catachronon", "catachronon@malignat.us"},
    time: "2050-01-01T00:00:00",
    recurring: :not_recurring
  }

  """
  def parse_file(file_body) do
    file_body
    |> lines
    |> Enum.map(&parse_line/1)
    |> Enum.into(%{})
    |> Enum.filter(fn {_, body} -> body != "" end)
    |> join_body_lines(%{})
    |> to_struct
  end

  @doc """
  Simply splits a text into lines. 

  iex> Parser.lines "Foo\\nbar"
  ["Foo", "bar"]

  """
  def lines(text) do
    String.split(text, "\n")
  end

  @doc """
  Makes a line into a "typed" item, later used for extracting properties from
  the file.

  iex> Parser.parse_line("- Title: Thing")
  {:title, "Thing"}

  iex> Parser.parse_line("")
  {:body, ""}

  iex> Parser.parse_line("- ")
  {:body, "- "}

  iex> Parser.parse_line("Hello there, I'm a mail body")
  {:body, "Hello there, I'm a mail body"}

  """
  def parse_line("- " <> body) do
    [title | content] = String.split(body, ":")

    body =
      content
      |> Enum.map(&String.trim/1)
      |> Enum.join(" ")

    fixed_title =
      title
      |> String.downcase()
      |> String.to_atom()

    {fixed_title, body}
  end

  def parse_line(line) do
    {:body, line}
  end

  def join_body_lines([{:body, text} | tl], %{body: previous_body} = acc) do
    updated_acc = %{acc | body: previous_body <> "\n" <> text}
    join_body_lines(tl, updated_acc)
  end

  def join_body_lines([{:body, text} | tl], acc) do
    join_body_lines(tl, Map.put(acc, :body, text))
  end

  def join_body_lines([{key, value} | tl], acc) do
    if Map.has_key?(acc, key) do
      raise "Duplicate key #{key}, file not parseable."
    end

    join_body_lines(tl, Map.put(acc, key, value))
  end

  def join_body_lines([], acc), do: acc

  def to_struct([{key, value} | tl]) do
    raise "Unimplemented"
  end
end
