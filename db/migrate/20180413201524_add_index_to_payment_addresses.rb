class AddIndexToPaymentAddresses < ActiveRecord::Migration
  def change
    add_index :payment_addresses, :account_id
  end
end
