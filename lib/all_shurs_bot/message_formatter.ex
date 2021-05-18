defmodule AllShursBot.MessageFormatter do
  alias AllShursBot.Model.User
  alias ExGram.Model.InlineQueryResultArticle
  alias ExGram.Model.InputTextMessageContent

  def format_register_message(), do: format_register_message([])

  def format_register_message([]) do
    reply_markup = generate_register_keyboard()
    {"There are no users registered yet!", reply_markup: reply_markup}
  end

  def format_register_message([%User{} | _] = users) do
    formatted_users =
      users |> Enum.map(fn user -> "  - #{format_user_name(user)}" end) |> Enum.join("\n")

    formatted_message = "**Registered users:**\n#{formatted_users}"

    reply_markup = generate_register_keyboard()

    {formatted_message, reply_markup: reply_markup}
  end

  def format_register_message(_) do
    {"**There was an error:** can not format the message", nil}
  end

  def generate_mention_article(text, users) do
    mention_message = format_mention_message(text, users)

    [
      %InlineQueryResultArticle{
        type: "article",
        id: 1,
        title: "@here #{text}",
        input_message_content: %InputTextMessageContent{
          message_text: mention_message,
          parse_mode: "Markdown"
        },
        description: "Mentions all registered members in this chat"
      }
    ]
  end

  def generate_register_article() do
    {message_text, reply_markup} = format_register_message()

    [
      %InlineQueryResultArticle{
        type: "article",
        id: 1,
        title: "Click here to register",
        input_message_content: %InputTextMessageContent{
          message_text: message_text,
          parse_mode: "Markdown"
        },
        reply_markup: reply_markup,
        description: "No registered members in this chat"
      }
    ]
  end

  # Utils
  defp format_user_name(%User{username: nil, first_name: first_name}), do: first_name

  defp format_user_name(%User{username: nil, first_name: nil, last_name: last_name}),
    do: last_name

  defp format_user_name(%User{username: nil, first_name: nil, last_name: nil, user_id: user_id}),
    do: "A random guy with this user_id #{user_id}"

  defp format_user_name(%User{username: username}), do: "@#{username}"

  defp generate_register_keyboard() do
    ExGram.Dsl.create_inline([[[text: "Register!", callback_data: "register"]]])
  end

  defp format_mention_message(text, users) do
    usernames = Enum.map(users, &"@#{&1.username || &1.first_name}")

    """
    #{usernames}

    #{text}
    """
  end
end
