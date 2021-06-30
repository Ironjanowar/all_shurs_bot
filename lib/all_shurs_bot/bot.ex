defmodule AllShursBot.Bot do
  @bot :all_shurs_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start")
  command("help", description: "Prints the bot's help")
  command("register", description: "Registers users in this chat")
  command("remove", description: "Removes an user from the registered users")

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, :help, _msg}, context) do
    message = AllShursBot.MessageFormatter.help_text()
    answer(context, message, parse_mode: "Markdown")
  end

  def handle({:command, :register, %{chat: %{id: chat_id} = chat}}, context) do
    {formatted_message, opts} = chat |> Map.put(:chat_id, chat_id) |> AllShursBot.register()
    opts = Keyword.merge([parse_mode: "Markdown"], opts)

    answer(context, formatted_message, opts)
  end

  def handle({:command, :remove, %{from: %{id: user_id} = user, chat: %{id: chat_id}}}, context) do
    {formatted_message, opts} =
      user |> Map.merge(%{chat_id: chat_id, user_id: user_id}) |> AllShursBot.remove_user()

    opts = Keyword.merge([parse_mode: "Markdown"], opts)
    answer(context, formatted_message, opts)
  end

  def handle(
        {:text, text, %{message_id: message_id, from: %{id: user_id}, chat: %{id: chat_id}}},
        context
      ) do
    with {:ok, answer_text} <- AllShursBot.mention_all(text, chat_id, user_id) do
      answer(context, answer_text, reply_to_message_id: message_id, parse_mode: "Markdown")
    end
  end

  def handle(
        {:callback_query,
         %{
           id: callback_query_id,
           data: "register",
           from: %{id: user_id} = user,
           message: %{chat: %{id: chat_id}}
         } = callback_query},
        context
      ) do
    require Logger

    register_result =
      user
      |> Map.merge(%{chat_id: chat_id, user_id: user_id})
      |> AllShursBot.register_user()

    case register_result do
      {:already_registered, _} ->
        Logger.warn("ALREADY REGISTERED")

        answer_callback(context, callback_query,
          text: "You are registered. Send /remove if you don't want to be mentioned"
        )

      {formatted_message, opts} ->
        Logger.warn("NOT REGISTERED")
        opts = Keyword.merge([parse_mode: "Markdown"], opts)
        ExGram.answer_callback_query(callback_query_id, text: "You have been registered!")
        edit(context, :inline, formatted_message, opts)
    end
  end
end
