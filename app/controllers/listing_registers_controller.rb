class ListingRegistersController < ApplicationController

  def index
    #@listing_registers = ListingRequest.all.with_aasm_state(:accepted).order("amount desc")
    #@listing_registers = ListingRequest.select(:ticker, :name, :home, :btt, :address, :amount).where(aasm_state: :approved).order("amount desc")

    sql = "select * from (select @rowid:=@rowid+1 as rowid, id, ticker, name, home, btt, address, COALESCE(amount, 0) as amount from listing_requests, (select @rowid:=0) as init where listing_requests.aasm_state='approved' order by amount desc) as t where t.amount >= 3000000";
    @listing_short_list = ListingRequest.find_by_sql(sql)

    sql = "select * from (select @rowid:=@rowid+1 as rowid, id, ticker, name, home, btt, address, COALESCE(amount, 0) as amount from listing_requests, (select @rowid:=0) as init where listing_requests.aasm_state='approved' order by amount desc) as t where t.amount < 3000000";
    @listing_registers = ListingRequest.find_by_sql(sql)

  end

end
