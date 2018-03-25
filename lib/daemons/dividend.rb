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

prev = Time.new

while($running) do
  t = Time.now
  if prev.hour != t.hour
  #if prev.min != t.min
    $stdout.print t.to_s + " new hour\n"
    Product.all.each do |product|
      $stdout.print "hour process product " + product[:name] + "\n"
      product.dividends.each do |dividend|
         $stdout.print "hour process dividend for member " + dividend[:member_id].to_s + "\n"
         #member = Member.find_by_id dividend[:member_id]
         #gio_account = member.accounts.with_currency(:gio).first
         account = dividend.asset
         if account
           #$stdout.print "test " + product.amount.to_s + "\n"
           hourly_dividend = (account.balance/product.amount).to_i * product.rate
           $stdout.print "hour result " + hourly_dividend.to_s + "\n"
           prev_div = nil
           if dividend.intraday_dividends.first
             prev_div = dividend.intraday_dividends.first.current
           end
           IntradayDividend.create(:dividend_id => dividend.id, :current => (account.balance/product.amount).to_i, :previous => prev_div, :profit => hourly_dividend);
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
        $stdout.print "day profit " + day_profit.to_s + "\n"
        DailyDividend.create(:dividend_id => dividend.id,  :profit => day_profit)
        dividend.interest.plus_funds(day_profit)
        dividend.intraday_dividends.destroy_all
      end
    end
  end
  prev = t
  sleep 3
end
