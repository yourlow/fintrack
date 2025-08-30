require "test_helper"

class ShortcutEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shortcut_entry = shortcut_entries(:one)
  end

  test "should get index" do
    get shortcut_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_shortcut_entry_url
    assert_response :success
  end

  test "should create shortcut_entry" do
    assert_difference("ShortcutEntry.count") do
      post shortcut_entries_url, params: { shortcut_entry: { account_id: @shortcut_entry.account_id, entry_type: @shortcut_entry.entry_type, shortcut_key_id: @shortcut_entry.shortcut_key_id } }
    end

    assert_redirected_to shortcut_entry_url(ShortcutEntry.last)
  end

  test "should show shortcut_entry" do
    get shortcut_entry_url(@shortcut_entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_shortcut_entry_url(@shortcut_entry)
    assert_response :success
  end

  test "should update shortcut_entry" do
    patch shortcut_entry_url(@shortcut_entry), params: { shortcut_entry: { account_id: @shortcut_entry.account_id, entry_type: @shortcut_entry.entry_type, shortcut_key_id: @shortcut_entry.shortcut_key_id } }
    assert_redirected_to shortcut_entry_url(@shortcut_entry)
  end

  test "should destroy shortcut_entry" do
    assert_difference("ShortcutEntry.count", -1) do
      delete shortcut_entry_url(@shortcut_entry)
    end

    assert_redirected_to shortcut_entries_url
  end
end
