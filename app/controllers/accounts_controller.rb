class AccountsController < ApplicationController
  include Trailblazer::Operation::Controller

  def index
    @accounts = AccountDecorator.decorate_collection Account.all
  end

  def debit
    Account::Debit.run(params) do |op|
      return redirect_to accounts_path
    end

    render :index
  end

end
