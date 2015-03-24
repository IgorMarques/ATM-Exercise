Rails.application.routes.draw do

  resources :accounts do
    member do
      post "/debit", to: "accounts#debit", as: :debit
      post "/credit", to: "accounts#credit", as: :credit
    end
  end

  root to: "accounts#index"

end
