class AddBalancedToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :balanced, :boolean, default: false, null: false
  end
end
