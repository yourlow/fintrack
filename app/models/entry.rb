class Entry < ApplicationRecord
  belongs_to :txn, class_name: "Transaction", foreign_key: "transaction_id"
  belongs_to :account

  after_save :update_transaction_balance
  after_destroy :update_transaction_balance

  enum :entry_type, {
    debit: "debit",
    credit: "credit"
  }

  scope :debits, -> { where(entry_type: "debit") }
  scope :credits, -> { where(entry_type: "credit") }

  def update_transaction_balance
    txn.update_balanced
  end



  def credit_amount
    entry_type == "credit" ? (amount.to_f / 100.0) : nil
  end

  def debit_amount
    entry_type == "debit" ? (amount.to_f / 100.0) : nil
  end

  def credit_amount=(val)
    self.amount = (val.to_d * 100).to_i if val.present?
    self.entry_type = "credit"
  end

  def debit_amount=(val)
    self.amount = (val.to_d * 100).to_i if val.present?
    self.entry_type = "debit"
  end
end
