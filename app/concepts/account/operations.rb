class Account < ActiveRecord::Base
  class Debit < Trailblazer::Operation
    attr_reader :model

    DebitForm = Struct.new(:account, :value)

    contract do
      property :account, validates: {presence: true}
      property :value, validates: {presence: true, numericality: true}
    end

    def process(params)
      @model = DebitForm

      validate(params, DebitForm.new(params)) do |f|
        account = Account.find(f.account)
        account.balance -= f.value
        account.save
      end

      self
    end

    def setup_params!(params)
      params.merge!({account: params[:id], value: BigDecimal.new(params[:process_transaction][:value])})
    end

  end

  class Credit < Trailblazer::Operation
    attr_reader :model

    CreditForm = Struct.new(:account, :value)

    contract do
      property :account, validates: {presence: true}
      property :value, validates: {presence: true, numericality: true}
    end

    def process(params)
      @model = CreditForm

      validate(params, CreditForm.new(params)) do |f|
        account = Account.find(f.account)
        account.balance += f.value
        account.save
      end

      self
    end

    def setup_params!(params)
      params.merge!({account: params[:id], value: BigDecimal.new(params[:process_transaction][:value])})
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
      end

      self
    end

    def setup_params!(params)
      params.merge!({account: params[:id], target_account: params[:process_transaction][:target_account], value: BigDecimal.new(params[:process_transaction][:value])})
    end

  end
end
