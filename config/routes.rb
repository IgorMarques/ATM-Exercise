Rails.application.routes.draw do

  resources :accounts do
    member do
      post "/process_transaction", to: "accounts#process_transaction", as: :process_transaction
    end
  end

  root to: "accounts#index"

end
