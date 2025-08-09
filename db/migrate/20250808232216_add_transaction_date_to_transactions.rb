class AddTransactionDateToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :transaction_date, :date
  end
end
  