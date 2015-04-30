# -*- encoding : utf-8 -*-
class AccountsController < ApplicationController
  include Trailblazer::Operation::Controller

  def index
    @accounts = AccountDecorator.decorate_collection Account.all
  end

  def process_transaction
    if params[:commit] == "DEBITAR"
      Account::Debit.run(params) do |op|
        if !op.errors.empty?
          return redirect_to accounts_path, notice: op.errors.messages[:value].first
        else
          return redirect_to accounts_path, notice: "Débito no valor #{params[:process_transaction][:value]} para a conta #{params[:id]} realizado com sucesso."
        end
      end
    elsif params[:commit] == "CREDITAR"
      Account::Credit.run(params) do |op|
        return redirect_to accounts_path, notice: "Crédito no valor #{params[:process_transaction][:value]} para a conta #{params[:id]} realizado com sucesso. Bônus de #{Account.find(params[:id]).bonus} creditado"
      end
    else params[:commit] == "TRANSFERIR"
      Account::Transfer.run(params) do |op|
        return redirect_to accounts_path, notice: "Transferência no valor #{params[:process_transaction][:value]} para a conta #{params[:process_transaction][:target_account]} realizado com sucesso."
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
