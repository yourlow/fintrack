require "application_system_test_case"

class ShortcutKeysTest < ApplicationSystemTestCase
  setup do
    @shortcut_key = shortcut_keys(:one)
  end

  test "visiting the index" do
    visit shortcut_keys_url
    assert_selector "h1", text: "Shortcut keys"
  end

  test "should create shortcut key" do
    visit shortcut_keys_url
    click_on "New shortcut key"

    fill_in "Combination", with: @shortcut_key.combination
    fill_in "Name", with: @shortcut_key.name
    click_on "Create Shortcut key"

    assert_text "Shortcut key was successfully created"
    click_on "Back"
  end

  test "should update Shortcut key" do
    visit shortcut_key_url(@shortcut_key)
    click_on "Edit this shortcut key", match: :first

    fill_in "Combination", with: @shortcut_key.combination
    fill_in "Name", with: @shortcut_key.name
    click_on "Update Shortcut key"

    assert_text "Shortcut key was successfully updated"
    click_on "Back"
  end

  test "should destroy Shortcut key" do
    visit shortcut_key_url(@shortcut_key)
    click_on "Destroy this shortcut key", match: :first

    assert_text "Shortcut key was successfully destroyed"
  end
end
