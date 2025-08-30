class ChangeCombinationToStringInShortcutKeys < ActiveRecord::Migration[8.0]
  def change
    change_column :shortcut_keys, :combination, :string
  end
end
