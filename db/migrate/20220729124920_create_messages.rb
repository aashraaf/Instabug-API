class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :token
      t.integer :chatNumber
      t.integer :number
      t.text :body

      t.timestamps
    end
  end
end
