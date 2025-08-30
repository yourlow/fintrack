require "application_system_test_case"

class ShortcutEntriesTest < ApplicationSystemTestCase
  setup do
    @shortcut_entry = shortcut_entries(:one)
  end

  test "visiting the index" do
    visit shortcut_entries_url
    assert_selector "h1", text: "Shortcut entries"
  end

  test "should create shortcut entry" do
    visit shortcut_entries_url
    click_on "New shortcut entry"

    fill_in "Account", with: @shortcut_entry.account_id
    fill_in "Entry type", with: @shortcut_entry.entry_type
    fill_in "Shortcut key", with: @shortcut_entry.shortcut_key_id
    click_on "Create Shortcut entry"

    assert_text "Shortcut entry was successfully created"
    click_on "Back"
  end

  test "should update Shortcut entry" do
    visit shortcut_entry_url(@shortcut_entry)
    click_on "Edit this shortcut entry", match: :first

    fill_in "Account", with: @shortcut_entry.account_id
    fill_in "Entry type", with: @shortcut_entry.entry_type
    fill_in "Shortcut key", with: @shortcut_entry.shortcut_key_id
    click_on "Update Shortcut entry"

    assert_text "Shortcut entry was successfully updated"
    click_on "Back"
  end

  test "should destroy Shortcut entry" do
    visit shortcut_entry_url(@shortcut_entry)
    click_on "Destroy this shortcut entry", match: :first

    assert_text "Shortcut entry was successfully destroyed"
  end
end
