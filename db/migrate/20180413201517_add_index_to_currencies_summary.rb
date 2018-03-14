class AddIndexToCurrenciesSummary < ActiveRecord::Migration
  def change
    add_index :currencies_summary, :slice
    add_index :turnover_summary, :slice
    add_index :currencies_summary, :created_at
    add_index :turnover_summary, :created_at
  end
end
