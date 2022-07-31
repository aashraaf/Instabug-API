class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.string :token
      t.integer :number
      t.integer :message_count

      t.timestamps
    end
  end
end
