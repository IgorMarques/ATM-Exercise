#require_relative "../concepts/accounts/business.rb"

class AccountsController < ApplicationController
  include Trailblazer::Operation::Controller

  def index
  end

  def debit
    run Account::Debit[params] do
      redirect_to accounts_path
    end
  end

end
