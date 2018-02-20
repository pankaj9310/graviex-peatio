@SettingsUI = flight.component ->
  @attributes
    gio_discount_mark: '#gio_discount_mark'

  @updateDiscounts  = ->
    #  0 - disabled
    #  1 - enabled
    # -1 - undefined
    gio_discount_flag = -1

    for currency, account of @accounts
      #console.log(account)
      if account.currency == 'gio' && account.hasOwnProperty('gio_discount')
        #console.log(account.currency, account.gio_discount)
        if account.gio_discount == true
          gio_discount_flag = 1
        if account.gio_discount == false
          gio_discount_flag = 0

    gio_discount_mark_node = @select('gio_discount_mark')
    #console.log(@select('gio_discount_mark'))
    if gio_discount_flag == 1
      #console.log("turning ON")
      gio_discount_mark_node.attr('class', 'fa fa-star')
      gio_discount_mark_node.attr('style', 'color: #e6b800')
    else if gio_discount_flag == 0
      #console.log("turning OFF")
      gio_discount_mark_node.attr('class', '_empty')
      gio_discount_mark_node.attr('style', '_empty')

    #console.log gon.current_user

  @after 'initialize', ->
    @accounts = gon.accounts

    @on document, 'account::update', (event, data) =>
      @accounts = data
      @updateDiscounts()

    @on document, 'market::tickers', (event, data) =>
      @tickers = data.raw
      @updateDiscounts()


