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
      params.merge!({account: params[:id], value: BigDecimal.new(params[:debit][:value])})
    end

  end
  
  class Credit < Trailblazer::Operation
    attr_reader :model

    Credit = Struct.new(:account, :value)

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
      params.merge!({account: params[:id], value: BigDecimal.new(params[:credit][:value])})
    end

  end
end
