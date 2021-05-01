defmodule AllShursBot.MessageFormatter do
  alias AllShursBot.Model.User

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
end
