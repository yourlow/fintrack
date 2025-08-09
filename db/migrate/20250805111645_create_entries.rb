class CreateEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :entries do |t|
      t.integer :transaction_id
      t.integer :account_id
      t.integer :amount
      t.string :entry_type

      t.timestamps
    end
  end
end
