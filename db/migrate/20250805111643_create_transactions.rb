class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.string :raw_description
      t.string :user_description
      t.integer :amount
      t.boolean :balanced

      t.timestamps
    end
  end
end
