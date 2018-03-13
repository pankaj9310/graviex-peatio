class AddUniqueIndexToDeposits < ActiveRecord::Migration
  def change
    remove_index :deposits, [:txid, :txout]
    add_index :deposits, [:txid, :txout], unique: true
    remove_index :payment_transactions, [:txid, :txout]
    add_index :payment_transactions, [:txid, :txout], unique: true
  end
end
