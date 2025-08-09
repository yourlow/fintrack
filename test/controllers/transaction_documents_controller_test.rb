require "test_helper"

class TransactionDocumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transaction_document = transaction_documents(:one)
  end

  test "should get index" do
    get transaction_documents_url
    assert_response :success
  end

  test "should get new" do
    get new_transaction_document_url
    assert_response :success
  end

  test "should create transaction_document" do
    assert_difference("TransactionDocument.count") do
      post transaction_documents_url, params: { transaction_document: { created_at: @transaction_document.created_at, description: @transaction_document.description, filepath: @transaction_document.filepath, transaction_id: @transaction_document.transaction_id, uploaded_at: @transaction_document.uploaded_at } }
    end

    assert_redirected_to transaction_document_url(TransactionDocument.last)
  end

  test "should show transaction_document" do
    get transaction_document_url(@transaction_document)
    assert_response :success
  end

  test "should get edit" do
    get edit_transaction_document_url(@transaction_document)
    assert_response :success
  end

  test "should update transaction_document" do
    patch transaction_document_url(@transaction_document), params: { transaction_document: { created_at: @transaction_document.created_at, description: @transaction_document.description, filepath: @transaction_document.filepath, transaction_id: @transaction_document.transaction_id, uploaded_at: @transaction_document.uploaded_at } }
    assert_redirected_to transaction_document_url(@transaction_document)
  end

  test "should destroy transaction_document" do
    assert_difference("TransactionDocument.count", -1) do
      delete transaction_document_url(@transaction_document)
    end

    assert_redirected_to transaction_documents_url
  end
end
