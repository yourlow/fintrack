class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :account_type

      t.timestamps
    end
  end
end
