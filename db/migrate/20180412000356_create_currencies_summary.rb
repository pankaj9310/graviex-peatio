class CreateCurrenciesSummary < ActiveRecord::Migration
  def change
    create_table :currencies_summary do |t|
      t.string  :currency
      t.decimal :locked, :precision => 32, :scale => 16
      t.decimal :balance, :precision => 32, :scale => 16
      t.decimal :hot, :precision => 32, :scale => 16
      t.timestamps
    end
    create_table :turnover_summary do |t|
      t.decimal :btc, :precision => 32, :scale => 16
      t.decimal :ltc, :precision => 32, :scale => 16
      t.decimal :doge, :precision => 32, :scale => 16
      t.decimal :eth, :precision => 32, :scale => 16
      t.timestamps
    end
  end
end
