@AccountSummaryUI = flight.component ->
  @attributes
    total_assets: '#total_assets'

  @updateAccount = (event, data) ->
    #console.log(event, data)
    for currency, account of data
      amount = (new BigNumber(account.locked)).plus(new BigNumber(account.balance))
      @$node.find("tr.#{currency} span.amount").text(formatter.round(amount, 4))
      @$node.find("tr.#{currency} span.locked").text(formatter.round(account.locked, 4))

  @updateTotalAssets = ->
    fiatCurrency = gon.fiat_currency
    symbol = gon.currencies[fiatCurrency].symbol
    sum = 0
    available = 0

    for currency, account of @accounts
      if currency is fiatCurrency
        available += +account.balance
        sum += +account.balance
        sum += +account.locked
      else if ticker = @tickers["#{currency}#{fiatCurrency}"]
        available += +account.balance * +ticker.last
        sum += +account.balance * +ticker.last
        sum += +account.locked * +ticker.last

    @select('total_assets').text "#{formatter.round sum, 1}/#{formatter.round available, 1}"

  @after 'initialize', ->
    @accounts = gon.accounts
    @tickers  = gon.tickers

    @on document, 'account::update', @updateAccount

    @on document, 'account::update', (event, data) =>
      @accounts = data
      @updateTotalAssets()

    @on document, 'market::tickers', (event, data) =>
      @tickers = data.raw
      @updateTotalAssets()


