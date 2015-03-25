class AccountDecorator < Draper::Decorator
  delegate_all

  def owner
    object.id.to_s +  " - " + object.owner
  end

  def balance
    "R$ " + object.balance.to_s.gsub(".", ",")
  end
end
