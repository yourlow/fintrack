class CreateShortcutEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :shortcut_entries do |t|
      t.references :shortcut_key, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.string :entry_type, null: false

      t.timestamps
    end
  end
end
