#!/usr/bin/env ruby

# You might want to change this
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
  sql = "select sum(fee*500.0) as result from account_versions where currency = #{currency} and reason = 110 and created_at >= '#{datefrom}' and created_at <= '#{dateto}' group by currency, reason"
  res = ActiveRecord::Base.connection.exec_query(sql).first
  amount = 0.0
  if res != nil
    amount = res['result'].to_f
  end
  return amount
end

$startup = true

while($running) do
  if $startup
    sleep 120
    $startup = false
  end
  begin
    date = DateTime.now
    ts = date.to_i
    currencies_summary = Currency.all.map(&:summary)
    currencies_summary.each do |ccy|
      hot = 'null'
      if ccy[:hot] != 'N/A'
        hot = ccy[:hot]
      end
      sql = "insert into currencies_summary (currency, locked, balance, hot, created_at, updated_at, slice) values ('#{ccy[:name]}', #{ccy[:locked]}, #{ccy[:balance]}, #{hot}, '#{date}', null, #{ts})"
      res = ActiveRecord::Base.connection.execute(sql)      
    end

    for i in 1..7
      datefrom = date.strftime("%Y-%m-%d 00:00:00")
      dateto = date.strftime("%Y-%m-%d 23:59:59")

      btc  = aggregate(2, datefrom, dateto)
      ltc  = aggregate(51, datefrom, dateto)
      doge = aggregate(3, datefrom, dateto)
      eth  = aggregate(52, datefrom, dateto)

      sql = "insert into turnover_summary (btc, ltc, doge, eth, created_at, updated_at, slice) values (#{btc}, #{ltc}, #{doge}, #{eth}, '#{datefrom}', null, #{ts})"
      res = ActiveRecord::Base.connection.execute(sql)
      date = date.ago(60*60*24)
    end

  rescue
    puts "Error: #{$!}"
    puts $!.backtrace.join("\n")
  end

  sleep 1800
end

