class CreateTransactionDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :transaction_documents do |t|
      t.integer :transaction_id
      t.string :filepath
      t.string :description

      t.timestamps
    end
  end
end
