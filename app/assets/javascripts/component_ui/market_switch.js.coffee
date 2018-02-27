window.MarketSwitchUI = flight.component ->
  @attributes
    table: 'tbody'
    marketGroupName: '.panel-body-head thead a.name'
    marketGroupItem: '.dropdown-wrapper .dropdown-menu li a'
    marketGroups: '.dropdown-wrapper .dropdown-menu'
    marketsTable: '.table.markets'
    marketsFilter: 'input'
    marketsList: 'tr.market'
    switchUnit: 'a.switch_unit'
    sortName: 'a.sort_name'
    sortUnit: 'a.sort_change'
    sortPrice: 'a.sort_price'
    sortNameDirection: 'span.name_sort_direction'
    sortUnitDirection: 'span.change_sort_direction'
    sortPriceDirection: 'span.price_sort_direction'

  @switchMarketGroup = (event, item) ->
    item = $(event.target).closest('a')
    name = item.data('name')

    @markets_filter = name

    @select('marketGroupItem').removeClass('active')
    item.addClass('active')

    @select('marketGroupName').text item.find('span').text()
    @select('marketsTable').attr("class", "table table-hover markets #{name}")
    @select('marketsTable').attr("style", "font-size: 12px")

  @setMarketGroup = (market_filter) ->
    @select('marketGroupItem').removeClass('active')
    
    marketGroup = @select('marketGroups').find("a[data-name='" + market_filter + "']")
    marketGroup.addClass('active')

    @select('marketGroupName').text marketGroup.find('span').text()
    @select('marketsTable').attr("class", "table table-hover markets #{market_filter}")
    @select('marketsTable').attr("style", "font-size: 12px")

  @updateMarket = (select, ticker) ->
    trend = formatter.trend ticker.last_trend

    curren_market = select[0]
    curren_market.attributes['class'].value = "market quote-" + ticker.quote_unit
    curren_market.attributes['data-market'].value = ticker.base_unit + ticker.quote_unit
    curren_market.attributes['id'].value = "market-list-" + ticker.base_unit + ticker.quote_unit

    if @markets_name_filter.length
      if curren_market.attributes['data-market'].value.indexOf(@markets_name_filter.toLowerCase()) >= 0
        curren_market.attributes['class'].value += " visible"
      else
        curren_market.attributes['class'].value += " hide"

    select.find('td.name')
      .html("<span class=''>#{ticker.name}</span>")

    select.find('td.price')
      .attr('title', ticker.last)
      .html("<span class='#{trend}'>#{formatter.ticker_price ticker.last}</span>")

    p1 = parseFloat(ticker.open)
    p2 = parseFloat(ticker.last)
    trend = formatter.trend(p1 <= p2)

    if @current_unit == 'volume' 
      select.find('td.change').html("<span class='#{trend}'>#{formatter.price_change(p1, p2)}%</span>")
    else
      select.find('td.change').html("<span class='#{trend}'>#{formatter.round(ticker.volume2, 4)}</span>")

  @refresh = (event, data) ->
    table = @select('table')
    records = @select('table').find("tr.market")

    recordsFound = []

    local_index = 0
    for ticker in data.tickers
      recordsFound.push(table.find("tr#"+records[local_index++].attributes['id'].value))

    local_index = 0
    for ticker in data.tickers
      @updateMarket recordsFound[local_index++], ticker.data
    @select('table').find("tr#market-list-#{gon.market.id}").addClass 'highlight'

  @filterMarkets = (filter) ->
    @markets_name_filter = filter
    local_markets = @select('marketsList')
    for market in local_markets
      market_class = market.attributes['class'].value
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

  @setUnit = (unit_name) ->
    @.unit = @select('switchUnit')
    @.selected = @.unit[0]
    if @.unit.hasClass('fa-percent') && unit_name == 'volume2'
      @updateColumnTransation(@.selected, 'fa-percent', 'fa-btc')
    else if @.unit.hasClass('fa-btc') && unit_name == 'volume'
      @updateColumnTransation(@.selected, 'fa-btc', 'fa-percent')

  @switchUnit = (e) ->
    @.unit = @select('switchUnit')
    @.selected = @.unit[0]
    if @.unit.hasClass('fa-percent')
      @updateColumnTransation(@.selected, 'fa-percent', 'fa-btc')
    else
      @updateColumnTransation(@.selected, 'fa-btc', 'fa-percent')

    current_column = @getCurrentUnit()
    if @current_column == 'volume2' || @current_column == 'volume'
      current_column_sort = 'unsorted'
      column = @select('sortUnit')
      if column.hasClass('desc')
        current_column_sort = 'desc'
      else
        if column.hasClass('asc')
          current_column_sort = 'asc'
    else
      current_column_sort = @columnOrder(@current_column)
      current_column = @current_column

    @trigger 'market::tickers::sort', { unit: current_column, order: current_column_sort }

  @getCurrentUnit = () ->
    unit = @select('switchUnit')
    selected = unit[0]
    if unit.hasClass('fa-percent')
      @current_unit = 'volume' 
    else
      @current_unit = 'volume2'
    return @current_unit

  @getColumn = (column_name) ->
    if column_name == 'volume' || column_name == 'volume2'
      column = @select('sortUnit')
    else if column_name == 'last'
      column = @select('sortPrice')
    else if column_name == 'name'
      column = @select('sortName')
    return column

  @getColumnDirection = (column_name) ->
    direction = null
    if column_name == 'volume' || column_name == 'volume2'
      direction = @select('sortUnitDirection')[0]
    else if column_name == 'last'
      direction = @select('sortPriceDirection')[0]
    else if column_name == 'name'
      direction = @select('sortNameDirection')[0]
    return direction

  @columnOrder = (column_name) ->
    column = @getColumn(column_name)

    if column_name == 'none'
      return 'unsorted'

    if column.hasClass('desc')
      return 'desc'
    else
      if column.hasClass('asc')
        return 'asc'
    return 'unsorted'

  @resetSort = (column_name) ->
    direction = @getColumnDirection(column_name)
    column = @getColumn(column_name)

    if column_name == 'none'
      return

    if column.hasClass('desc')
      @updateColumnTransation(column[0], 'desc', 'unsorted')
      @updateColumnTransation(direction, 'fa-sort-desc', 'fa-unsorted')
    else
      if column.hasClass('asc')
        @updateColumnTransation(column[0], 'asc', 'unsorted')
        @updateColumnTransation(direction, 'fa-sort-asc', 'fa-unsorted')

  @sortColumn = (column_name, column_order) ->
    if column_name == 'none'
      return

    if column_name != @current_column
      @resetSort(@current_column)

    direction = @getColumnDirection(column_name)
    column = @getColumn(column_name)

    prev_column_sort = 'unsorted' 
    current_column_sort = 'unsorted'
 
    if column_order != 'none'
      @resetSort(column_name)
      @updateColumnTransation(column[0], 'unsorted', column_order)
      current_column_sort = column_order
    else
      if column.hasClass('unsorted')
        @updateColumnTransation(column[0], 'unsorted', 'desc')
        current_column_sort = 'desc'
      else 
        if column.hasClass('desc') 
          @updateColumnTransation(column[0], 'desc', 'asc')
          current_column_sort = 'asc'
          prev_column_sort = 'desc'
        else
          if column.hasClass('asc')
            @updateColumnTransation(column[0], 'asc', 'desc')
            current_column_sort = 'desc'
            prev_column_sort = 'asc'

    if prev_column_sort == 'unsorted' && current_column_sort == 'desc'
       @updateColumnTransation(direction, 'fa-unsorted', 'fa-sort-desc')
    else if prev_column_sort == 'unsorted' && current_column_sort == 'asc'
       @updateColumnTransation(direction, 'fa-unsorted', 'fa fa-sort-asc')
    else if prev_column_sort == 'desc' && current_column_sort == 'asc'
       @updateColumnTransation(direction, 'fa-sort-desc', 'fa-sort-asc')
    else if prev_column_sort == 'asc' && current_column_sort == 'desc'
       @updateColumnTransation(direction, 'fa-sort-asc', 'fa-sort-desc')

    @current_column = column_name
#    console.log @current_column, current_column_sort
    @trigger 'market::tickers::sort', { unit: @current_column, order: current_column_sort }

  @sortUnit = (e) ->
    @sortColumn(@getCurrentUnit(), 'none')

  @sortPrice = (e) ->
    @sortColumn('last', 'none')

  @sortName = (e) ->
    @sortColumn('name', 'none')

  @updateColumnTransation = (selected, from, to) ->
    if selected.attributes['class'].value.indexOf(from) > 0
      selected.attributes['class'].value = selected.attributes['class'].value.substr(0, selected.attributes['class'].value.indexOf(from) - 1)
      selected.attributes['class'].value += " " + to

  @switchMarket = (e) ->
    parameters = '?'+'markets='+@markets_filter+'&column='+@current_column+'&order='+@columnOrder(@current_column)+'&unit='+@current_unit
    unless e.target.nodeName == 'I'
      window.location.href = window.formatter.market_url($(e.target).closest('tr').data('market')+parameters)

  @after 'initialize', ->
    @on document, 'market::tickers', @refresh
    @on @select('marketGroupItem'), 'click', @switchMarketGroup
    @on @select('marketsFilter'), 'keydown', @filterEditing
    @on @select('switchUnit'), 'click', @switchUnit
    @on @select('sortUnit'), 'click', @sortUnit
    @on @select('sortPrice'), 'click', @sortPrice
    @on @select('sortName'), 'click', @sortName
    @on @select('table'), 'click', @switchMarket

    @markets_filter = gon.markets_filter
    @current_column = gon.markets_column
    @current_unit = gon.markets_unit
    @markets_name_filter = ''

    @resetSort('name')

    @setMarketGroup @markets_filter
    @sortColumn @current_column, gon.markets_column_order
    @setUnit @current_unit

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
