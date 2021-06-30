defmodule AllShursBot.MessageFormatter do
  alias AllShursBot.Model.User

  def help_text() do
    """
    Register everybody in the group by sending /register and clicking in the provided button.

    Mention every registered member by starting a message with:
      - `@here`
      - `@all`
      - `@shures`
      - `@todos`

    If you don't want to be mentioned by the bot no more send /remove
    """
  end

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

  def format_answer_message([%User{} | _] = users) do
    answer_text = users |> Enum.map(&format_user_mention/1) |> Enum.join(" ")
    {:ok, answer_text}
  end

  def format_answer_message(_) do
    {:error, "Can not format invalid users"}
  end

  def format_remove_message(%User{} = user) do
    formatted_user = format_user_name(user)
    formatted_message = "#{formatted_user} is not going to be mentioned anymore"

    {formatted_message, []}
  end

  def format_already_removed_message(attrs) do
    formatted_user = format_user_name(attrs)
    formatted_message = "#{formatted_user} is not registered"

    {formatted_message, []}
  end

  # Utils
  defp format_user_mention(%{
         username: nil,
         first_name: first_name,
         last_name: last_name,
         user_id: user_id
       }),
       do: "[#{first_name || last_name}](tg://user?id=#{user_id})"

  defp format_user_mention(%{username: username}), do: "@#{username}"

  defp format_user_name(%{
         username: nil,
         first_name: first_name,
         last_name: last_name
       }),
       do: "`#{first_name || last_name}`"

  defp format_user_name(%{username: username}), do: "`@#{username}`"

  defp generate_register_keyboard() do
    ExGram.Dsl.create_inline([[[text: "Register!", callback_data: "register"]]])
  end
end
