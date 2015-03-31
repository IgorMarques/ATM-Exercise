class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.decimal :balance
      t.string  :owner
      t.decimal :bonus
    end
  end
end
