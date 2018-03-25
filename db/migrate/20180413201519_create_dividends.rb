class CreateDividends < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string  :name
      t.string  :description
      t.integer :asset
      t.integer :interest
      t.integer :maturation
      t.decimal :amount, :precision => 32, :scale => 16
      t.decimal :rate, :precision => 32, :scale => 16
      t.text    :contract
      t.timestamps
    end    
    create_table :dividends do |t|
      t.integer :member_id
      t.integer :product_id
      t.string :aasm_state
      t.timestamps
    end
    create_table :intraday_dividends do |t|
      t.integer :dividend_id
      t.decimal :current, :precision => 32, :scale => 16
      t.decimal :previous, :precision => 32, :scale => 16
      t.decimal :profit, :precision => 32, :scale => 16      
      t.timestamps
    end
    create_table :daily_dividends do |t|
      t.integer :dividend_id
      t.decimal :profit, :precision => 32, :scale => 16
      t.timestamps
    end

    add_index :intraday_dividends, [:dividend_id, :created_at]
    add_index :daily_dividends, [:dividend_id, :created_at]

    Product.create :name => "default", :description => "GIO/BTC/60/24", :asset => 1, :interest => 2, :maturation => 60, :amount => 1000.0, :rate => 0.000000001369
  end
end
