window.GlobalData = flight.component ->

  @refreshDocumentTitle = (event, data) ->
    symbol = gon.currencies[gon.market.bid.currency].symbol
    price  = data.last
    market = [gon.market.ask.currency, gon.market.bid.currency].join("/").toUpperCase()
    brand  = "GRAVIEX Exchange"

    document.title = "#{symbol}#{price} #{market} - #{brand}"

  @refreshDepth = (data) ->
    asks = []
    bids = []
    [bids_sum, asks_sum] = [0, 0]

    _.each data.asks, ([price, volume]) ->
      asks.push [parseFloat(price), asks_sum += parseFloat(volume)]

    _.each data.bids, ([price, volume]) ->
      bids.push [parseFloat(price), bids_sum += parseFloat(volume)]

    @trigger 'market::depth::response', 
      asks: asks, bids: bids

  @refreshTicker = (data) ->
    unless @last_tickers
      for market, ticker of data
        data[market]['buy_trend'] = data[market]['sell_trend'] = data[market]['last_trend'] = true
      @last_tickers = data

    tickers = for market, ticker of data
      buy = parseFloat(ticker.buy)
      sell = parseFloat(ticker.sell)
      last = parseFloat(ticker.last)
      last_buy = parseFloat(@last_tickers[market].buy)
      last_sell = parseFloat(@last_tickers[market].sell)
      last_last = parseFloat(@last_tickers[market].last)

      open = parseFloat(ticker.open)
      ticker.volumeRelFloat = parseFloat(formatter.price_change(open, last))
      ticker.lastFloat = last
      ticker.volumeAbsFloat = parseFloat(ticker.volume2)

      if buy != last_buy
        data[market]['buy_trend'] = ticker['buy_trend'] = (buy > last_buy)
      else
        ticker['buy_trend'] = @last_tickers[market]['buy_trend']

      if sell != last_sell
        data[market]['sell_trend'] = ticker['sell_trend'] = (sell > last_sell)
      else
        ticker['sell_trend'] = @last_tickers[market]['sell_trend']

      if last != last_last
        data[market]['last_trend'] = ticker['last_trend'] = (last > last_last)
      else
        ticker['last_trend'] = @last_tickers[market]['last_trend']

      if market == gon.market.id
        @trigger 'market::ticker', ticker

      market: market, data: ticker, unit: @sort_unit, order: @sort_order

    tickers_sorted = tickers.sort(@sorter)
#    console.log tickers_sorted
    @trigger 'market::tickers', {tickers: tickers_sorted, raw: data}
    @last_tickers = data
    
  @sorter = (a, b) ->
    if a.order == 'unsorted' || a.unit == 'empty' 
      return 0

    if a.data[a.unit] < b.data[a.unit]
      if a.order == 'asc'
        return -1
      return 1
    else if a.data[a.unit] > b.data[a.unit]
      if a.order == 'asc'
        return 1
      return -1
    else
      return 0

  @refreshTickers = (event, data) ->
    if @last_tickers
      @refreshTicker(@last_tickers)
    else if gon.tickers
      @refreshTicker(gon.tickers)

  @sortTickers = (event, data) ->
    @sort_unit = data.unit

    if @sort_unit == 'volume'
      @sort_unit = 'volumeRelFloat'
    else if @sort_unit == 'last'
      @sort_unit = 'lastFloat'
    else if @sort_unit == 'volume2'
      @sort_unit = 'volumeAbsFloat'

    @sort_order = data.order

    if @last_tickers
      @refreshTicker(@last_tickers)
    else if gon.tickers
      @refreshTicker(gon.tickers)

  @after 'initialize', ->
    @on document, 'market::ticker', @refreshDocumentTitle
    @on document, 'market::tickers::force', @refreshTickers
    @on document, 'market::tickers::sort', @sortTickers

    @sort_unit = 'empty'
    @sort_order = 'unsorted'

    @last_tickers = null

    global_channel = @attr.pusher.subscribe("market-global")
    market_channel = @attr.pusher.subscribe("market-#{gon.market.id}-global")

    global_channel.bind 'tickers', (data) =>
      @refreshTicker(data)

    market_channel.bind 'update', (data) =>
      gon.asks = data.asks
      gon.bids = data.bids
      @trigger 'market::order_book::update', asks: data.asks, bids: data.bids
      @refreshDepth asks: data.asks, bids: data.bids 

    market_channel.bind 'trades', (data) =>
      @trigger 'market::trades', {trades: data.trades}

    # Initializing at bootstrap
    if gon.ticker
      @trigger 'market::ticker', gon.ticker

    if gon.tickers
      @refreshTicker(gon.tickers)

    if gon.asks and gon.bids
      @trigger 'market::order_book::update', asks: gon.asks, bids: gon.bids
      @refreshDepth asks: gon.asks, bids: gon.bids 

    if gon.trades # is in desc order initially
      # .reverse() will modify original array! It makes gon.trades sorted
      # in asc order afterwards
      @trigger 'market::trades', trades: gon.trades.reverse()
