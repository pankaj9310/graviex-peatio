class Withdraw extends PeatioModel.Model
  @configure 'Withdraw', 'sn', 'account_id', 'member_id', 'currency', 'amount', 'fee', 'fund_uid', 'fund_extra',
    'created_at', 'updated_at', 'done_at', 'txid', 'blockchain_url', 'aasm_state', 'sum', 'type', 'is_submitting'

  constructor: ->
    super
    @is_submitting = @aasm_state == "submitting"

  @initData: (records) ->
    PeatioModel.Ajax.disable ->
      $.each records, (idx, record) ->
        Withdraw.create(record)

  afterScope: ->
    "#{@pathName()}"

  pathName: ->
    switch @currency
      when 'gio' then 'gravios'
      when 'btc' then 'satoshis'
      when 'doge' then 'doges'
      when 'ltc' then 'ltcs'
      when 'eth' then 'ethers'
      when 'psd' then 'poseidons'
      when 'phc' then 'profithunters'
      when 'xgc' then 'xgoldcoins'
      when 'dev' then 'deviants'
      when 'pbs' then 'phoboscoins'
      when 'din' then 'dineros'
      when 'adv' then 'advances'
      when 'dv7' then 'dv7coins'
      when 'jew' then 'shekels'
      when 'argo' then 'argos'
      when 'esco' then 'escrows'
      when 'neet' then 'neetcoins'
      when 'xylo' then 'xylos'
      when 'steep' then 'steepcoins'
      when 'bitg' then 'bitcoingreens'
      when 'crft' then 'craftrs'
      when 'env' then 'enviromints'
      when 'sng' then 'snowgems'
      when 'nyc' then 'newyorkcoins'
      when 'zoc' then 'zeroonecoins'
      when 'btcz' then 'bitcoinzs'
      when 'ytn' then 'yentens'
      when 'yic' then 'yicoins'
      #currency

window.Withdraw = Withdraw
