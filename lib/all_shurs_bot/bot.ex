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
    {formatted_message, opts} = chat |> Map.put(:chat_id, chat_id) |> AllShursBot.register()
    opts = Keyword.merge([parse_mode: "Markdown"], opts)

    answer(context, formatted_message, opts)
  end

  def handle(
        {:callback_query,
         %{
           data: "register",
           from: %{id: user_id} = user,
           message: %{chat: %{id: chat_id}}
         }} = message,
        context
      ) do
    case user
         |> Map.merge(%{chat_id: chat_id, user_id: user_id})
         |> AllShursBot.register_user() do
      {:already_registered, _} ->
        answer_callback(context, message, text: "You are already registered", show_alert: true)

      {formatted_message, opts} ->
        opts = Keyword.merge([parse_mode: "Markdown"], opts)
        edit(context, :inline, formatted_message, opts)
    end
  end
end
