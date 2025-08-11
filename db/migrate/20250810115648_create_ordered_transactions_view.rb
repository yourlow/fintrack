class CreateOrderedTransactionsView < ActiveRecord::Migration[7.1]
  def up
    execute <<~SQL
      CREATE VIEW ordered_transactions AS
      SELECT
        t.*,
        ROW_NUMBER() OVER (ORDER BY t.transaction_date ASC, t.id ASC) AS computed_index
      FROM transactions t;
    SQL
  end

  def down
    execute <<~SQL
      DROP VIEW IF EXISTS ordered_transactions;
    SQL
  end
end
