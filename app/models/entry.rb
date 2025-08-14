class Entry < ApplicationRecord
  belongs_to :txn, class_name: "Transaction", foreign_key: "transaction_id"
  belongs_to :account

  enum :entry_type, {
    debit: "debit",
    credit: "credit"
  }
end
