class Entry < ApplicationRecord
  belongs_to :transaction
  belongs_to :account

  enum entry_type: {
    debit: "debit",
    credit: "credit"
  }
end