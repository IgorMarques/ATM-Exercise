class Account < ActiveRecord::Base
  class Debit < Trailblazer::Operation

    contract do
      property :account, validates: {presence: true}
      property :value,  validates: {presence: true}
    end

    def process(params)
      validate(params, Struct.new(params)) do
        account = Account.find(params[:account])

        account.balance -= params[:value]

        account.save
      end
    end
  end
end