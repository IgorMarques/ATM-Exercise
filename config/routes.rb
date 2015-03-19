Rails.application.routes.draw do

  resources :accounts do
    member do
      post "/debit", to: "accounts#debit", as: :debit
    end
  end

end
