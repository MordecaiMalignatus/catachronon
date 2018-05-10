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

  def parse_file(file_body) do
    file_body
    |> lines
    |> parse_line
    |> Enum.into(%{})
    |> Enum.filter(fn {_, body} -> body != "" end)
    |> join_body_lines([])
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
  end

  def parse_line(line) do
    {:body, line}
  end

  def join_body_lines([{:body, text} | tl], acc) do
    join_body_lines(tl, %{acc | :body => acc[:body] <> " " <> text})
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
