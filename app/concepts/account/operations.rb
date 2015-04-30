# -*- encoding : utf-8 -*-
class Account < ActiveRecord::Base
  class Debit < Trailblazer::Operation
    attr_reader :model

    DebitForm = Struct.new(:account, :value, :description)

    contract do
      property :account, validates: {presence: true}
      property :description, validates: {presence: true}
      property :value, validates: {presence: true, numericality: true}
    end

    def process(params)
      @model = DebitForm

      validate(params, DebitForm.new(params)) do |f|
        account = Account.find(f.account)
        account.balance -= f.value

        if account.balance >= 2
          account.save
        else
          self.errors.add(:value, "O saldo mínimo em conta deverá ser R$ 2,00")
        end

        Log.create(info: "DÉBITO DE #{f.value} NA CONTA #{f.account}/#{f.description}")
      end

      self
    end

    def setup_params!(params)
      params.merge!({account: params[:id], value: BigDecimal.new(params[:process_transaction][:value])})
    end

  end

  class Credit < Trailblazer::Operation
    attr_reader :model

    CreditForm = Struct.new(:account, :value, :description)

    contract do
      property :account, validates: {presence: true}
      property :description, validates: {presence: true}
      property :value, validates: {presence: true, numericality: true}
    end

    def process(params)
      @model = CreditForm

      validate(params, CreditForm.new(params)) do |f|
        account = Account.find(f.account)
        account.balance += f.value + (f.value * 0.03)

        account.save

        Log.create(info: "CRÉDITO DE #{f.value} NA CONTA #{f.account}/#{f.description}")
      end

      self
    end

    def setup_params!(params)
      params.merge!({
        account: params[:id], value: BigDecimal.new(params[:process_transaction][:value]),
        description: params[:process_transaction][:description]
      })
    end

  end

  class Transfer < Trailblazer::Operation
    attr_reader :model

    TransferForm = Struct.new(:account, :value, :target_account)

    contract do
      property :account, validates: {presence: true}
      property :value, validates: {presence: true, numericality: true}
      property :target_account, validates: {presence: true, numericality: true}
    end

    def process(params)
      @model = TransferForm

      validate(params, TransferForm.new(params)) do |f|
        account = Account.find(f.account)
        account.balance -= f.value
        account.save

        target = Account.find(f.target_account)
        target.balance += f.value
        target.save

        Log.create(info: "TRANSFERÊNCIA DE #{f.value} DA CONTA #{f.account} PARA #{f.target_account}")
      end

      self
    end

    def setup_params!(params)
      params.merge!({account: params[:id], target_account: params[:process_transaction][:target_account], value: BigDecimal.new(params[:process_transaction][:value])})
    end

  end
end
