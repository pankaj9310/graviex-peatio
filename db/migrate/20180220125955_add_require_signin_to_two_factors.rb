class AddRequireSigninToTwoFactors < ActiveRecord::Migration
  def change
    add_column :two_factors, :require_signin, :integer
  end
end
