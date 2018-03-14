class AddSliceToCurrenciesSummary < ActiveRecord::Migration
  def change
    add_column :currencies_summary, :slice, :integer
    add_column :turnover_summary, :slice, :integer
  end
end
