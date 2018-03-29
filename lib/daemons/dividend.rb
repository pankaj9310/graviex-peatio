#!/usr/bin/env ruby

ENV["RAILS_ENV"] ||= "development"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do
  $running = false
end

def aggregate(currency, datefrom, dateto)
  sql = "select sum(fee) as result from account_versions where currency = #{currency} and reason = 110 and created_at >= '#{datefrom}' and created_at <= '#{dateto}' group by currency, reason"
  res = ActiveRecord::Base.connection.exec_query(sql).first
  amount = 0.0
  if res != nil
    amount = res['result'].to_f
  end
  return amount
end

prev = Time.new

while($running) do
  t = Time.now
  hour_begin = t - 60*60
  if prev.hour != t.hour
  #if prev.min != t.min
    $stdout.print t.to_s + " new hour\n"
    Product.all.each do |product|
      $stdout.print "hour process product " + product[:name] + "\n"
      fee = aggregate(product.interest, hour_begin, t)
      currency_code = Currency.find(product.asset).code
      if !currency_code
        next
      end
      blocks_count = Rails.cache.read("peatio:hotwallet:" + currency_code + ":blocks") || 575000.0
      dividend_rate = (fee / 2.0) /  blocks_count.to_f
      volume = fee*500
      #$stdout.print "hour dividend rate " + dividend_rate.to_s + " volume " + volume.to_s + "\n"
      $stdout.print "hour blocks count " + blocks_count.to_s + " dividend rate " + dividend_rate.to_s + " volume " + volume.to_s + "\n"
      product.dividends.each do |dividend|
         $stdout.print "hour process dividend for member " + dividend[:member_id].to_s + "\n"
         #member = Member.find_by_id dividend[:member_id]
         #gio_account = member.accounts.with_currency(:gio).first
         account = dividend.asset
         if account
           #$stdout.print "test " + product.amount.to_s + "\n"
           hourly_dividend = (account.balance/product.amount).to_i * dividend_rate
           $stdout.print "hour result " + hourly_dividend.to_s + "\n"
           prev_div = nil
           if dividend.intraday_dividends.first
             prev_div = dividend.intraday_dividends.first.current
           end
           IntradayDividend.create(:dividend_id => dividend.id, :current => account.balance, :previous => volume, :profit => hourly_dividend);
         end

         #$stdout.print member[:email] + "\n"
      end
    end
  end
  if prev.day != t.day
  #if prev.min != t.min
  #if prev.hour != t.hour
    $stdout.print t.to_s + " new day\n"
    day_begin = t - 23.5*60*60
    Product.all.each do |product|
      $stdout.print "day process product " + product[:name] + " day begin " + day_begin.to_s + "\n"
      product.dividends.each do |dividend|
        $stdout.print "day process dividend for member " + dividend[:member_id].to_s + "\n"
        day_profit = dividend.intraday_dividends.where(["created_at > ?", day_begin]).sum(:profit)
        day_volume = dividend.intraday_dividends.where(["created_at > ?", day_begin]).sum(:previous)
        $stdout.print "day profit " + day_profit.to_s + "\n"
        DailyDividend.create(:dividend_id => dividend.id,  :profit => day_profit, :volume => day_volume)
        if day_profit > 0
          dividend.interest.plus_funds(day_profit)
        end
        dividend.intraday_dividends.destroy_all
      end
    end
  end
  prev = t
  sleep 3
end
