json.extract! transaction, :id, :raw_description, :user_description, :amount, :balanced, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
