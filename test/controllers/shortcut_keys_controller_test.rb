require "test_helper"

class ShortcutKeysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shortcut_key = shortcut_keys(:one)
  end

  test "should get index" do
    get shortcut_keys_url
    assert_response :success
  end

  test "should get new" do
    get new_shortcut_key_url
    assert_response :success
  end

  test "should create shortcut_key" do
    assert_difference("ShortcutKey.count") do
      post shortcut_keys_url, params: { shortcut_key: { combination: @shortcut_key.combination, name: @shortcut_key.name } }
    end

    assert_redirected_to shortcut_key_url(ShortcutKey.last)
  end

  test "should show shortcut_key" do
    get shortcut_key_url(@shortcut_key)
    assert_response :success
  end

  test "should get edit" do
    get edit_shortcut_key_url(@shortcut_key)
    assert_response :success
  end

  test "should update shortcut_key" do
    patch shortcut_key_url(@shortcut_key), params: { shortcut_key: { combination: @shortcut_key.combination, name: @shortcut_key.name } }
    assert_redirected_to shortcut_key_url(@shortcut_key)
  end

  test "should destroy shortcut_key" do
    assert_difference("ShortcutKey.count", -1) do
      delete shortcut_key_url(@shortcut_key)
    end

    assert_redirected_to shortcut_keys_url
  end
end
