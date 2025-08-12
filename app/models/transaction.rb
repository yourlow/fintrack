class Transaction < ApplicationRecord
  has_many :entries
  has_many :transaction_documents


  scope :pending, -> { where(balanced: false) }

  ORDER_COL = "transaction_date" # or "view_date"

  scope :ordered_for_index, -> {
    reorder(Arel.sql("#{ORDER_COL} ASC, id ASC"))
  }

  scope :with_computed_index, -> {
    select(
      Arel.sql(%(transactions.*, ROW_NUMBER() OVER (ORDER BY #{ORDER_COL}, id) AS computed_index))
    ).ordered_for_index
  }

  scope :window_by_index, ->(start_index, length: 20) {
    inner = with_computed_index

    from(inner, :ordered)
      .select(Arel.sql("ordered.*")) # <-- critical: stop selecting "transactions".*
      .where("computed_index BETWEEN ? AND ?", start_index, start_index + length - 1)
      .order(Arel.sql("computed_index ASC"))
  }

  def self.find_by_computed_index(idx)
    from(with_computed_index, :ordered)
      .select(Arel.sql("ordered.*"))
      .where("computed_index = ?", idx)
      .take
  end
end
