class Transaction < ApplicationRecord
  has_many :entries
  has_many :transaction_documents

  accepts_nested_attributes_for :entries

  scope :pending, -> { where(balanced: false) }

  scope :ordered, -> { order(transaction_date: :asc, id: :asc) }






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


  def update_balanced
    return if entries.count == 0

    net = entries.sum(
    "CASE entry_type
       WHEN 'debit'  THEN amount
       WHEN 'credit' THEN -amount
     END"
  )
  self.balanced = ((net - amount) == 0)


  self.save!
  end
end
