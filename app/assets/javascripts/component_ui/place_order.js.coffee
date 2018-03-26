@PlaceOrderUI = flight.component ->
  @attributes
    formSel: 'form'
    successSel: '.status-success'
    infoSel: '.status-info'
    feeSel: '.status-fee'
    dangerSel: '.status-danger'
    priceAlertSel: '.hint-price-disadvantage'
    positionsLabelSel: '.hint-positions'
    feeLabelSel: '.hint-fee'
    feeLabelInfo: '.fee-info'
    feeLabelDiscountInfo: '.fee-discount-info'

    priceSel: 'input[id$=price]'
    volumeSel: 'input[id$=volume]'
    totalSel: 'input[id$=total]'
    bidSel: "input[id='calculate_bid']"
    askSel: "input[id='calculate_ask']"

    currentBalanceSel: 'span.current-balance'
    submitButton: ':submit'

  @panelType = ->
    switch @$node.attr('id')
      when 'bid_entry' then 'bid'
      when 'ask_entry' then 'ask'

  @cleanMsg = ->
    @select('successSel').text('')
    @select('infoSel').text('')
    @select('dangerSel').text('')
    @select('feeSel').text('')

  @resetForm = (event) ->
    @trigger 'place_order::reset::price'
    @trigger 'place_order::reset::volume'
    @trigger 'place_order::reset::total'
    @priceAlertHide()

  @disableSubmit = ->
    @select('submitButton').addClass('disabled').attr('disabled', 'disabled')

  @enableSubmit = ->
    @select('submitButton').removeClass('disabled').removeAttr('disabled')

  @confirmDialogMsg = ->
    confirmType = @select('submitButton').text()
    price = @select('priceSel').val()
    volume = @select('volumeSel').val()
    sum = @select('totalSel').val()
    """
    #{gon.i18n.place_order.confirm_submit} "#{confirmType}"?

    #{gon.i18n.place_order.price}: #{price}
    #{gon.i18n.place_order.volume}: #{volume}
    #{gon.i18n.place_order.sum}: #{sum}
    """

  @beforeSend = (event, jqXHR) ->
    if true #confirm(@confirmDialogMsg())
      @disableSubmit()
    else
      jqXHR.abort()

  @handleSuccess = (event, data) ->
    @cleanMsg()
    @select('successSel').append(JST["templates/hint_order_success"]({msg: data.message})).show()
    @resetForm(event)
    window.sfx_success()
    @enableSubmit()

  @handleError = (event, data) ->
    @cleanMsg()
    ef_class = 'shake shake-constant hover-stop'
    json = JSON.parse(data.responseText)
    console.log(json)
    @select('dangerSel').append(JST["templates/hint_order_warning"]({msg: json.message})).show()
      .addClass(ef_class).wait(500).removeClass(ef_class)
    window.sfx_warning()
    @enableSubmit()

  @getBalance = ->
    BigNumber( @select('currentBalanceSel').data('balance') )

  @getLastPrice = ->
    BigNumber(gon.ticker.last)

  @allIn = (event)->
    switch @panelType()
      when 'ask'
        @trigger 'place_order::input::volume', {volume: @getBalance()}
      when 'bid'
        @trigger 'place_order::input::total', {total: @getBalance()}

  @refreshBalance = (event, data) ->
    type = @panelType()
    currency = gon.market[type].currency
    balance = gon.accounts[currency]?.balance || 0

#    console.log "refreshBalance: ", type, balance, event, data

    @select('currentBalanceSel').data('balance', balance)
    @select('currentBalanceSel').text(formatter.fix(type, balance))

    @trigger "place_order::balance::change", balance: BigNumber(balance)
    @trigger "place_order::max::#{@usedInput}", max: BigNumber(balance)
    @trigger "place_order::balance::change::#{type}", balance: BigNumber(balance)

  @roundValueToText = (v, precision) ->
    v.round(precision, BigNumber.ROUND_DOWN).toF(precision)

  @updateOrder = (event, data) ->
#    console.log "updateOrder: ", event, data
    
    @select('priceSel').val BigNumber(data.price).round(gon.market.bid.fixed, BigNumber.ROUND_DOWN).toF(gon.market.bid.fixed)
    @select('volumeSel').val BigNumber(data.volume).round(gon.market.ask.fixed, BigNumber.ROUND_DOWN).toF(gon.market.ask.fixed)
    @select('totalSel').val BigNumber(data.total).round(gon.market.bid.fixed, BigNumber.ROUND_DOWN).toF(gon.market.bid.fixed)

    @updateAvailable(event, data)

  @updateAvailable = (event, order) ->
#    console.log "updateAvailable: ", event, order

    @current_order = order

    type = @panelType()
    node = @select('currentBalanceSel')

    order[@usedInput] = 0 unless order[@usedInput]
    available = formatter.fix type, @getBalance().minus(order[@usedInput])

    fee = 0.0
    fee_actual_percent = 0.0

    if type == 'ask'
      fee = gon.market.ask.fee
    else
      fee = gon.market.bid.fee

    gio_discount_flag = -1

    if gon.accounts != undefined
      gio_account = gon.accounts['gio']
      if gio_account.hasOwnProperty('gio_discount')
        if gio_account.gio_discount == true
          gio_discount_flag = 1
        if gio_account.gio_discount == false
          gio_discount_flag = 0

    fee_actual_percent = fee
    if gio_discount_flag == 1
      fee_actual_percent = fee / 2.0

    if order.hasOwnProperty('total')
      order.fee = order.total * fee
    else
      order.fee = order[@usedInput] * fee

    order.fee_percent = fee * 100.0
    order.fee_actual_percent = fee_actual_percent * 100.0
    order.gio_discount_flag = gio_discount_flag

    if @select('priceSel').val() != 0.0 && @select('priceSel').val() != ''
      @select('feeLabelSel').hide().text(formatter.fixPriceGroup(order.fee)).fadeIn()
      @select('feeLabelInfo').hide().text(formatter.round(order.fee_actual_percent, 2) + "%").fadeIn()
    else
      @select('feeLabelSel').fadeOut().text('')
      @select('feeLabelInfo').fadeOut().text('')

    if order.gio_discount_flag == 1
      @select('feeLabelDiscountInfo').fadeOut().text('')
    else
      @select('feeLabelDiscountInfo').hide().text('how to get 50% market fee discount').fadeIn()

    if BigNumber(available).lessThan(0.000000001)
      @select('positionsLabelSel').hide().text(gon.i18n.place_order["full_#{type}"]).fadeIn()
    else
      @select('positionsLabelSel').fadeOut().text('')

    node.text(available)

  @priceAlertHide = (event) ->
    @select('priceAlertSel').fadeOut ->
      $(@).text('')

  @priceAlertShow = (event, data) ->
    @select('priceAlertSel')
      .hide().text(gon.i18n.place_order[data.label]).fadeIn()

  @clear = (e) ->
    if e.currentTarget.checked
      @disableSubmit()
      @refreshBalance(null, null)
      @trigger "place_order::max::#{@usedInput}", max: BigNumber("1000000000000.0")
      @trigger "place_order::balance::change::#{@panelType()}", balance: BigNumber("1000000000000.0")
    else
      @enableSubmit()
      @refreshBalance(null, null)

    @resetForm(e)
    @select('feeLabelSel').fadeOut().text('')
    @select('feeLabelInfo').fadeOut().text('')
    @trigger 'place_order::focus::price'

  @calculatorClick = (e) ->
#    console.log @panelType(), e

    @clear(e)

  @after 'initialize', ->
    type = @panelType()

    if type == 'ask'
      @usedInput = 'volume'
    else
      @usedInput = 'total'

    @current_order = null

    PlaceOrderData.attachTo @$node
    OrderPriceUI.attachTo   @select('priceSel'),  form: @$node, type: type
    OrderVolumeUI.attachTo  @select('volumeSel'), form: @$node, type: type
    OrderTotalUI.attachTo   @select('totalSel'),  form: @$node, type: type

    @on 'place_order::price_alert::hide', @priceAlertHide
    @on 'place_order::price_alert::show', @priceAlertShow
    @on 'place_order::order::updated', @updateAvailable
    @on 'place_order::clear', @clear
    @on 'place_order::order::total', @updateOrder

    @on document, 'account::update', @refreshBalance

    @on @select('formSel'), 'ajax:beforeSend', @beforeSend
    @on @select('formSel'), 'ajax:success', @handleSuccess
    @on @select('formSel'), 'ajax:error', @handleError

    @on @select('currentBalanceSel'), 'click', @allIn

    if @panelType() == 'bid'
      @on @select('bidSel'), 'click', @calculatorClick
    else
      @on @select('askSel'), 'click', @calculatorClick



