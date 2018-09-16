defmodule Catachronon.Parser.Parser do
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

  This is littered with proper examples in the test file.
  """
  def parse_file(file_body) do
    file_body
    |> lines
    |> Enum.map(&parse_line/1)
    |> join_body_lines(%{})
    |> Enum.into(%{})
    |> take_relevant_items
    |> Map.to_list()
    |> to_task_struct
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
  {:"", ""}

  iex> Parser.parse_line("Hello there, I'm a mail body")
  {:body, "Hello there, I'm a mail body"}

  """
  def parse_line("- " <> body) do
    [title | content] = String.split(body, ":")

    body =
      content
      |> Enum.map(&String.trim/1)
      |> Enum.join(":")

    fixed_title =
      title
      |> String.downcase()
      |> String.to_atom()

    {fixed_title, body}
  end

  def parse_line(line) do
    {:body, line}
  end

  @doc """
  Joins the body lines in the Task.

  iex> Parser.join_body_lines([{:body, "Hello there"}], %{body: "Previously on..."})
  %{body: "Previously on...\\nHello there"}
  """
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

  @doc """
  Extract relevant struct items from parsed map. This drops any and all
  unsupported keys irrecoverably, so if the struct later expands, the data is
  not held.
  """
  def take_relevant_items(map) do
    relevant_keys = [
      :body,
      :title,
      :from,
      :to,
      :recurring,
      :time
    ]

    Map.take(map, relevant_keys)
  end

  def to_task_struct(keyword_list) do
    to_task_struct(keyword_list, %Catachronon.Task{})
  end

  def to_task_struct([{_, nil} | tl], struct) do
    to_task_struct(tl, struct)
  end

  def to_task_struct([{key, value} | tl], struct) do
    to_task_struct(tl, %{struct | key => value})
  end

  def to_task_struct([], struct) do
    struct
  end
end
