Rails.application.routes.draw do

  resources :accounts do
    member do
      post "/process_transaction", to: "accounts#process_transaction", as: :process_transaction
      # post "/debit", to: "accounts#debit", as: :debit
      # post "/credit", to: "accounts#credit", as: :credit
    end
  end

  root to: "accounts#index"

end
