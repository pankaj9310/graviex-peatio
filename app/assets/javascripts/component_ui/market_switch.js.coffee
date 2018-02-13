window.MarketSwitchUI = flight.component ->
  @attributes
    table: 'tbody'
    marketGroupName: '.panel-body-head thead span.name'
    marketGroupItem: '.dropdown-wrapper .dropdown-menu li a'
    marketsTable: '.table.markets'
    marketsFilter: 'input'
    marketsList: 'tr.market'

  @switchMarketGroup = (event, item) ->
    item = $(event.target).closest('a')
    name = item.data('name')

#    window.markets_filter = name
#    console.log 'switchMarketGroup', window.markets_filter

    @select('marketGroupItem').removeClass('active')
    item.addClass('active')

    @select('marketGroupName').text item.find('span').text()
    @select('marketsTable').attr("class", "table table-hover markets #{name}")
    @select('marketsTable').attr("style", "font-size: 12px")

  @setMarketGroup = (market_filter) ->
    console.log 'setMarketGroup', market_filter

    @select('marketsTable').attr("class", "table table-hover markets #{market_filter}")
    @select('marketsTable').attr("style", "font-size: 12px")

  @updateMarket = (select, ticker) ->
    trend = formatter.trend ticker.last_trend

    select.find('td.price')
      .attr('title', ticker.last)
      .html("<span class='#{trend}'>#{formatter.ticker_price ticker.last}</span>")

    p1 = parseFloat(ticker.open)
    p2 = parseFloat(ticker.last)
    trend = formatter.trend(p1 <= p2)
    select.find('td.change').html("<span class='#{trend}'>#{formatter.price_change(p1, p2)}%</span>")

  @refresh = (event, data) ->
    table = @select('table')
    for ticker in data.tickers
      @updateMarket table.find("tr#market-list-#{ticker.market}"), ticker.data
    table.find("tr#market-list-#{gon.market.id}").addClass 'highlight'

  @filterMarkets = (filter) ->
    local_markets = @select('marketsList')
    for market in local_markets
      market_class = market.attributes['class'].value
      console.log market.attributes['data-market'].value, filter
      if market.attributes['data-market'].value.indexOf(filter.toLowerCase()) >= 0 || !filter.length
        if market_class.indexOf('hide') >= 0
          market.attributes['class'].value = market_class.substr(0, market_class.indexOf('hide') - 1)
        if market_class.indexOf('visible') == -1
          market.attributes['class'].value += " visible"
      else
        if market_class.indexOf('visible') >= 0
          market.attributes['class'].value = market_class.substr(0, market_class.indexOf('visible') - 1)
        if market_class.indexOf('hide') == -1
          market.attributes['class'].value += " hide"

  @filterEditing = (e) ->
    char = e.key
    filter = e.currentTarget.value
    if char.length == 1
     filter += char
    else if char == 'Backspace'
      filter = filter.substring(0, filter.length-1)
    else if char != 'Enter'
      e.currentTarget.value = ''
      filter = ''

    @filterMarkets filter

  @after 'initialize', ->
    @on document, 'market::tickers', @refresh
    @on @select('marketGroupItem'), 'click', @switchMarketGroup
    @on @select('marketsFilter'), 'keydown', @filterEditing

#    if window.markets_filter
#      @setMarketGroup window.markets_filter

    @select('table').on 'click', 'tr', (e) ->
      unless e.target.nodeName == 'I'
        window.location.href = window.formatter.market_url($(@).data('market'))

    @.hide_accounts = $('tr.hide')

    $('.view_all_accounts').on 'click', (e) =>
      $el = $(e.currentTarget)
      if @.hide_accounts.hasClass('show1')
        $el.text($el.data('show-text'))
        for acc in @.hide_accounts
          if acc.lastChild.firstChild.textContent != '0.0000'
            if acc.attributes['class'].value.indexOf('show1') > 0
              acc.attributes['class'].value = acc.attributes['class'].value.substr(0, acc.attributes['class'].value.indexOf('show1') - 1)
              acc.attributes['class'].value += " hide"
      else if @.hide_accounts.hasClass('hide')
        $el.text($el.data('hide-text'))
        for acc in @.hide_accounts
          if acc.lastChild.firstChild.textContent != '0.0000'
            if acc.attributes['class'].value.indexOf('hide') > 0
              acc.attributes['class'].value = acc.attributes['class'].value.substr(0, acc.attributes['class'].value.indexOf('hide') - 1)
              acc.attributes['class'].value += " show1"
