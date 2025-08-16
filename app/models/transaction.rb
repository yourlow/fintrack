class Transaction < ApplicationRecord
  has_many :entries
  has_many :transaction_documents

  accepts_nested_attributes_for :entries





  scope :pending, -> { where(balanced: false) }

  scope :ordered, -> { order(transaction_date: :asc, id: :asc) }




  def amount_dollars
    return nil if amount.nil?
    (amount.to_f / 100).round(2)
  end

  def amount_dollars=(val)
    self.amount = val.present? ? (BigDecimal(val) * 100).to_i : nil
  end

  def next
  Transaction.ordered
              .where("transaction_date > :d OR (transaction_date = :d AND id > :i)",
                    d: transaction_date, i: id)
              .first
  end

  def prev
    Transaction.ordered
               .where("transaction_date < :d OR (transaction_date = :d AND id < :i)",
                      d: transaction_date, i: id)
               .reverse_order
               .first
  end
end
