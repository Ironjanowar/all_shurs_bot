defmodule AllShursBotTest do
  use ExUnit.Case
  doctest AllShursBot

  test "greets the world" do
    assert AllShursBot.hello() == :world
  end
end
