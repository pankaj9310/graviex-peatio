class AddExplanationToWithdraws < ActiveRecord::Migration
  def change
    add_column :withdraws, :explanation, :string
  end
end
