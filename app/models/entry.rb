class Entry < ApplicationRecord
  belongs_to :txn, class_name: "Transaction"
  belongs_to :account

  enum :entry_type, {
    debit: "debit",
    credit: "credit"
  }
end
