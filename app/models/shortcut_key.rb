class ShortcutKey < ApplicationRecord
  has_many :shortcut_entries, dependent: :destroy

  validates :name, presence: true
  validates :combination, presence: true
  # validate :must_have_at_least_two_entries


  accepts_nested_attributes_for :shortcut_entries, allow_destroy: true


  def must_have_at_least_two_entries
    valid_entries = shortcut_entries.reject(&:marked_for_destruction?)
    if valid_entries.size < 2
      errors.add(:base, "must have at least two entries")
    end
  end
end
