# app/models/ordered_transaction.rb
class OrderedTransaction < ApplicationRecord
  self.table_name = "ordered_transactions"
  def readonly? = true

  scope :pending, -> { where(balanced: false) }


  # Optional helpers
  scope :window, ->(start_idx, length = 20) {
    where("computed_index BETWEEN ? AND ?", start_idx, start_idx + length - 1)
      .order(Arel.sql("computed_index ASC"))
  }

  def self.computed_index_for(date:, id:)
    # 1-based position for (date, id) under (date, id) ordering, even if the row doesn’t exist in the view
    Transaction.where("date < :d OR (date = :d AND id < :i)", d: date, i: id).count + 1
  end
end
