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

while($running) do
  Currency.all.each do |currency|
    begin
      $stdout.print "Processing coin = " + currency.code + " (" 
      currency.refresh_balance if currency.coin?
      currency.refresh_status if currency.coin?
      if currency.is_online == "online" 
        $stdout.print "+" + currency.is_online + ")\n"
      else
        $stdout.print "-" + currency.is_online + ")\n"
      end
    rescue => ex
      $stdout.print "?" + currency.is_online + ")\n"
      $stderr.print "[error]: " + ex.message + "\n" + ex.backtrace.join("\n") + "\n"
    end
  end

  sleep 5
end
