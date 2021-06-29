defmodule AllShursBot.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:user_id, :string, null: false)
      add(:chat_id, references(:chats, column: :chat_id, type: :string), null: false)
      add(:username, :string)
      add(:first_name, :string)
      add(:last_name, :string)

      timestamps()
    end

    create index(:users, [:user_id, :chat_id], unique: true)
  end
end
