class CreateShortcutKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :shortcut_keys do |t|
      t.string :name
      t.text :combination

      t.timestamps
    end
  end
end
