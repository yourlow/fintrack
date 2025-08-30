class ShortcutEntry < ApplicationRecord
  belongs_to :shortcut_key
  belongs_to :account


  enum :entry_type, {
    debit: "debit",
    credit: "credit"
  }

  validates :entry_type, presence: true
end
