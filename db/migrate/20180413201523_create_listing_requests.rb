class CreateListingRequests < ActiveRecord::Migration
  def self.up
    create_table :listing_requests do |t|
      t.string  :ticker
      t.string  :name
      t.string  :algo
      t.string  :codebase
      t.string  :source
      t.string  :be
      t.string  :home
      t.string  :btt
      t.string  :lang
      t.string  :email
      t.string  :discord
      t.string  :twitter
      t.string  :reddit
      t.string  :facebook
      t.string  :telegram
      t.text    :comment
      t.string  :secret
      t.string  :address
      t.decimal :amount, :precision => 32, :scale => 16
      t.string :aasm_state
      t.timestamps
    end    

    add_index :listing_requests, [:amount, :created_at]
  end
end
