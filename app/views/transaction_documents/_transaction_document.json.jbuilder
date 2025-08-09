json.extract! transaction_document, :id, :transaction_id, :filepath, :description, :created_at, :uploaded_at, :created_at, :updated_at
json.url transaction_document_url(transaction_document, format: :json)
