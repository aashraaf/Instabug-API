class AddDescriptionToChats < ActiveRecord::Migration[7.0]
  def change
    add_column :chats, :description, :string
  end
end
