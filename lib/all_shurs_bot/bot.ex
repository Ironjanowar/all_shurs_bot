defmodule AllShursBot.Bot do
  @bot :all_shurs_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start")
  command("help", description: "Print the bot's help")
  command("register", description: "Register users for the current")

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, :help, _msg}, context) do
    answer(context, "Here is your help:")
  end

  def handle({:command, :register, %{chat: %{id: chat_id} = chat}}, context) do
    case chat |> Map.put(:chat_id, chat_id) |> AllShursBot.register() do
      {formatted_message, nil} ->
        answer(context, formatted_message, parse_mode: "Markdown")

      {formatted_message, reply_markup} ->
        answer(context, formatted_message, parse_mode: "Markdown", reply_markup: reply_markup)
    end
  end

  def handle(
        {:callback_query,
         %{
           data: "register",
           from: %{id: user_id} = user,
           message: %{chat: %{id: chat_id}}
         }},
        context
      ) do
    case user
         |> Map.merge(%{chat_id: chat_id, user_id: user_id})
         |> AllShursBot.register_user() do
      {:already_registered, _} ->
        nil

      {formatted_message, nil} ->
        edit(context, :inline, formatted_message, parse_mode: "Markdown")

      {formatted_message, reply_markup} ->
        edit(context, :inline, formatted_message,
          parse_mode: "Markdown",
          reply_markup: reply_markup
        )
    end
  end
end
