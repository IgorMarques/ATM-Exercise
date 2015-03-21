class AccountsController < ApplicationController
  include Trailblazer::Operation::Controller

  def index
  end

  def debit
    Account::Debit.run(params) do |op|
      return redirect_to accounts_path
    end

    render :index
  end

end
