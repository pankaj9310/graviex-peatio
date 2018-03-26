class AddVolumeToDailyDividends < ActiveRecord::Migration
  def change
    add_column :daily_dividends, :volume, :decimal, precision: 32, scale: 16
  end end

