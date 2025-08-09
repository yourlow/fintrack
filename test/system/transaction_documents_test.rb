require "application_system_test_case"

class TransactionDocumentsTest < ApplicationSystemTestCase
  setup do
    @transaction_document = transaction_documents(:one)
  end

  test "visiting the index" do
    visit transaction_documents_url
    assert_selector "h1", text: "Transaction documents"
  end

  test "should create transaction document" do
    visit transaction_documents_url
    click_on "New transaction document"

    fill_in "Created at", with: @transaction_document.created_at
    fill_in "Description", with: @transaction_document.description
    fill_in "Filepath", with: @transaction_document.filepath
    fill_in "Transaction", with: @transaction_document.transaction_id
    fill_in "Uploaded at", with: @transaction_document.uploaded_at
    click_on "Create Transaction document"

    assert_text "Transaction document was successfully created"
    click_on "Back"
  end

  test "should update Transaction document" do
    visit transaction_document_url(@transaction_document)
    click_on "Edit this transaction document", match: :first

    fill_in "Created at", with: @transaction_document.created_at.to_s
    fill_in "Description", with: @transaction_document.description
    fill_in "Filepath", with: @transaction_document.filepath
    fill_in "Transaction", with: @transaction_document.transaction_id
    fill_in "Uploaded at", with: @transaction_document.uploaded_at.to_s
    click_on "Update Transaction document"

    assert_text "Transaction document was successfully updated"
    click_on "Back"
  end

  test "should destroy Transaction document" do
    visit transaction_document_url(@transaction_document)
    click_on "Destroy this transaction document", match: :first

    assert_text "Transaction document was successfully destroyed"
  end
end
