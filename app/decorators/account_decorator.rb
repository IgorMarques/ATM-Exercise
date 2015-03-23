class AccountDecorator < Draper::Decorator
  delegate_all

  def balance
    "R$ " + object.balance.to_s.gsub(".", ",")
  end
end
