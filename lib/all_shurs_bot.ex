defmodule AllShursBot do
  @moduledoc """
  Documentation for `AllShursBot`.
  """

  alias AllShursBot.MessageFormatter
  alias AllShursBot.Model.{Chat, User}

  require Logger

  def register(%{chat_id: _} = chat) do
    with {:ok, chat} <- Chat.get_or_insert(chat),
         users <- User.get_users_from_chat(chat) do
      MessageFormatter.format_register_message(users)
    else
      {:error, error} ->
        Logger.error(inspect(error))
        {"**There was an error**", []}

      error ->
        Logger.error("Unexpected error: #{inspect(error)}")
        {"**There was an error**", []}
    end
  end

  def register(_) do
    {"**There was an error:** not enought data to store the chat", nil}
  end

  def register_user(%{chat_id: chat_id} = attrs) do
    with {:ok, _user} <- User.insert(attrs),
         users <- User.get_users_from_chat(chat_id) do
      MessageFormatter.format_register_message(users)
    else
      {:error, error} when is_binary(error) ->
        {"**There was an error:** #{error}", nil}

      {:error, %Ecto.Changeset{} = error} ->
        Logger.error("Changeset error: #{inspect(error)}")
        {:already_registered, nil}

      error ->
        Logger.error("Unexpected error: #{inspect(error)}")
        {"**There was an error**", nil}
    end
  end

  def register_user(_) do
    {"**There was an error:** chat_id not provided", nil}
  end

  def mention_all(text, chat_id, user_id) do
    if is_mention(text) do
      users = User.get_all_users_in_chat(chat_id, except: user_id)
      MessageFormatter.format_answer_message(users)
    else
      {:error, "No mention detected"}
    end
  end

  @valid_mention_triggers ["@here ", "@all ", "@shures ", "@todos ", "@putos "]
  def is_mention(text) when is_binary(text) do
    String.starts_with?(text, @valid_mention_triggers)
  end

  def is_mention(_), do: false
end
