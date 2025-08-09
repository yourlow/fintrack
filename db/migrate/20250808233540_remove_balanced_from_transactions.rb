class RemoveBalancedFromTransactions < ActiveRecord::Migration[8.0]
  def change
    remove_column :transactions, :balanced, :boolean
  end
end
