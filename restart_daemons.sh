# stop
bundle exec rake daemon:dividend:stop
bundle exec rake daemon:matching:stop
bundle exec rake daemon:withdraw_coin:stop
bundle exec rake daemon:notification:stop
bundle exec rake daemon:withdraw_audit:stop
bundle exec rake daemon:market_data:stop
bundle exec rake daemon:hot_wallets:stop
bundle exec rake daemon:payment_transaction:stop
bundle exec rake daemon:k:stop
bundle exec rake daemon:websocket_api:stop
bundle exec rake daemon:stats:stop
bundle exec rake daemon:pusher:stop
bundle exec rake daemon:global_state:stop
bundle exec rake daemon:currencies_stats:stop

bundle exec rake TRADE_EXECUTOR=5 daemon:trade_executor:stop
bundle exec rake DEPOSIT_COIN_ADDRESS=8 daemon:deposit_coin_address:stop
bundle exec rake ORDER_PROCESSOR=5 daemon:order_processor:stop

bundle exec rake DEPOSIT_COIN=5 daemon:deposit_coin:stop
# start
bundle exec rake DEPOSIT_COIN=5 daemon:deposit_coin:start

bundle exec rake daemon:dividend:start
bundle exec rake daemon:matching:start
bundle exec rake daemon:withdraw_coin:start
bundle exec rake daemon:notification:start
bundle exec rake daemon:withdraw_audit:start
bundle exec rake daemon:market_data:start
bundle exec rake daemon:hot_wallets:start
bundle exec rake daemon:payment_transaction:start
bundle exec rake daemon:k:start
bundle exec rake daemon:websocket_api:start
bundle exec rake daemon:stats:start
bundle exec rake daemon:pusher:start
bundle exec rake daemon:global_state:start
bundle exec rake daemon:currencies_stats:start

bundle exec rake TRADE_EXECUTOR=5 daemon:trade_executor:start
bundle exec rake DEPOSIT_COIN_ADDRESS=8 daemon:deposit_coin_address:start
bundle exec rake ORDER_PROCESSOR=5 daemon:order_processor:start


