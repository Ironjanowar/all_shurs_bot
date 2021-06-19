defmodule AllShursBot.Model.Chat do
  use Ecto.Schema

  alias AllShursBot.Repo
  alias AllShursBot.Model.User
  import Ecto.Changeset

  schema "chats" do
    field(:chat_id, :string, null: false)
    field(:type, :string)
    field(:username, :string)
    field(:first_name, :string)
    field(:last_name, :string)

    has_many(:user, User)

    timestamps()
  end

  @chat_fields [
    :chat_id,
    :type,
    :username,
    :first_name,
    :last_name
  ]

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @chat_fields)
    |> validate_required([:chat_id])
  end

  def get_or_insert(chat) do
    chat_id = to_string(chat[:chat_id])
    chat = %{chat | chat_id: chat_id}

    case Repo.get_by(__MODULE__, chat_id: chat_id) do
      nil -> chat |> changeset() |> Repo.insert()
      chat -> {:ok, chat}
    end
  end

  def get_or_insert!(chat) do
    {:ok, chat} = get_or_insert(chat)
    chat
  end
end
