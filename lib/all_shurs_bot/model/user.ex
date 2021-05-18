defmodule AllShursBot.Model.User do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias __MODULE__
  alias AllShursBot.Model.Chat
  alias AllShursBot.Repo

  schema "users" do
    field(:user_id, :integer, null: false)
    field(:username, :string)
    field(:first_name, :string)
    field(:last_name, :string)

    belongs_to(:chat, Chat)

    timestamps()
  end

  @user_fields [
    :user_id,
    :chat_id,
    :username,
    :first_name,
    :last_name
  ]

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @user_fields)
    |> validate_required([:user_id])
    |> unique_constraint(:user_id)
  end

  def insert(attrs), do: attrs |> changeset() |> Repo.insert()

  def get_users_from_chat(%Chat{chat_id: chat_id}) do
    get_users_from_chat(chat_id)
  end

  def get_users_from_chat(chat_id) when is_integer(chat_id) do
    from(user in User, where: user.chat_id == ^chat_id) |> Repo.all()
  end

  def get_users_from_chat(_) do
    {:error, "can not get users from chat"}
  end

  def get_all_users_in_chat(chat_id, opts \\ []) do
    from(user in User, where: ^chat_id == user.chat_id)
    |> add_exception(opts[:except])
    |> Repo.all()
  end

  # Private
  defp add_exception(query, nil), do: query
  defp add_exception(query, user_id), do: where(query, [user], user.user_id != ^user_id)
end
