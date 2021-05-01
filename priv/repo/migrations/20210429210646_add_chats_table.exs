defmodule AllShursBot.Repo.Migrations.AddChatsTable do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add(:chat_id, :integer, null: false)
      add(:type, :string)
      add(:username, :string)
      add(:first_name, :string)
      add(:last_name, :string)

      timestamps()
    end

    create index(:chats, [:chat_id], unique: true)
  end
end
