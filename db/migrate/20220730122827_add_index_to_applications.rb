class AddIndexToApplications < ActiveRecord::Migration[7.0]
  def change
    add_index :applications, :token
    add_index :chats, :token
    add_index :chats, :number
    add_index :messages, :token
    add_index :messages, :chatNumber
    add_index :messages, :number
  end
end
