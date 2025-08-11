class Transaction < ApplicationRecord
  has_many :entries
  has_many :transaction_documents


  scope :pending, -> { where(balanced: false) }


  def self.next_from(id, count = 20)
    start = find_by(id: id)
    return none unless start

    return order(:transaction_date, :created_at, :id).where(
      "transaction_date > :d
       OR (transaction_date = :d AND (created_at > :c
           OR (created_at = :c AND id > :id)))",
      d: start.transaction_date,
      c: start.created_at,
      id: start.id
    ).limit(count), start
  end
end
