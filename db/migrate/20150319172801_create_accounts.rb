# -*- encoding : utf-8 -*-
class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.decimal :balance
      t.string  :owner
      t.decimal :bonus, default: 0
    end
  end
end
