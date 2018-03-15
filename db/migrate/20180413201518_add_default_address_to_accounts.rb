class AddDefaultAddressToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :default_address, :string
  end
end
