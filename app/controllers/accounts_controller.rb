class AccountsController < ApplicationController
  include Trailblazer::Operation::Controller

  def index
    @accounts = AccountDecorator.decorate_collection Account.all
  end

  def process_transaction

    if params[:commit] == "DEBITAR"
      Account::Debit.run(params) do |op|
        return redirect_to accounts_path
      end
    elsif params[:commit] == "CREDITAR"
      Account::Credit.run(params) do |op|
        return redirect_to accounts_path
      end
    else params[:commit] == "TRANSFERIR"
      Account::Transfer.run(params) do |op|
        return redirect_to accounts_path
      end
    end

    redirect_to accounts_path
  end

  def debit
    Account::Debit.run(params) do |op|
      return redirect_to accounts_path
    end
        render :index
  end

  def credit
    Account::Credit.run(params) do |op|
      return redirect_to accounts_path
    end
    render :index
  end

end
