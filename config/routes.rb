Rails.application.routes.draw do
  resources :shortcut_entries
  resources :shortcut_keys
  resources :entries
  resources :transaction_documents

  resources :transactions do
    post :shortcut, on: :member
    collection do
      get :bulk_upload
      post :bulk_upload
      get :frame
    end
  end


  resources :accounts
  resources :users

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "accounts#index"
end
