class Entry < ApplicationRecord
  belongs_to :txn, class_name: "Transaction", foreign_key: "transaction_id"
  belongs_to :account

  after_save :update_transaction_balance
  after_destroy :update_transaction_balance

  enum :entry_type, {
    debit: "debit",
    credit: "credit"
  }



  def update_transaction_balance
    txn.update_balanced
  end
end
