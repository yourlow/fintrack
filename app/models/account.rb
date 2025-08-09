class Account < ApplicationRecord
  has_many :entries

  enum :account_type, {
    asset: "asset",
    capital: "capital",
    liabilities: "liabilities",
    revenues: "revenues",
    expenses: "expenses"
  }
end
