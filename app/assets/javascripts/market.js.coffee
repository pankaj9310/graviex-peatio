#= require es5-shim.min
#= require es5-sham.min
#= require jquery
#= require jquery_ujs
#= require jquery.mousewheel
#= require jquery-timing.min
#= require jquery.nicescroll.min
#
#= require bootstrap
#= require bootstrap-switch.min
#
#= require moment
#= require bignumber
#= require underscore
#= require cookies.min
#= require flight.min
#= require pusher.min

#= require ./lib/sfx
#= require ./lib/notifier
#= require ./lib/pusher_connection

#= require highstock
#= require_tree ./highcharts/

#= require_tree ./helpers
#= require_tree ./component_mixin
#= require_tree ./component_data
#= require_tree ./component_ui
#= require_tree ./templates

#= require_self

$ ->
  window.notifier = new Notifier()

  window.onresize = (event) ->
    if gon.markets_pinned == 'false'
      @markets_height = $("[id='market_list']").css("height")
      @trades_height = $("[id='market_trades']").css("height")

      @total_height = (parseInt(@markets_height, 10) + parseInt(@trades_height, 10))
      $('left_side_tabs_wrapper').css("height", @total_height)

  BigNumber.config(ERRORS: false)

#  if window.innerWidth < 1600
#    console.log 'window.location.href = ' + window.location.href
#    
#    @current_url = window.location.href
#    if @current_url.indexOf('pinned=false') == -1
#      if @current_url.indexOf('pinned=true') >= 0
#        @current_url = @current_url.replace('pinned=true', 'pinned=false') 
#      else 
#        if @current_url.indexOf('pinned=') == -1
#          if @current_url.indexOf('?') == -1
#            @current_url += '?pinned=false'
#          else
#            @current_url += '&pinned=false'
#      window.location.href = @current_url

  HeaderUI.attachTo('header')
  AccountSummaryUI.attachTo('#account_summary')
  SettingsUI.attachTo('#settings')

  FloatUI.attachTo('.float')
  KeyBindUI.attachTo(document)
  AutoWindowUI.attachTo(window)

  PlaceOrderUI.attachTo('#bid_entry')
  PlaceOrderUI.attachTo('#ask_entry')
  OrderBookUI.attachTo('#order_book')
  DepthUI.attachTo('#depths_wrapper')

  MyOrdersUI.attachTo('#my_orders')
  MarketTickerUI.attachTo('#ticker')
  MarketTradesUI.attachTo('#market_trades_wrapper')

  MarketData.attachTo(document)
  GlobalData.attachTo(document, {pusher: window.pusher})
  MarketSwitchUI.attachTo('#market_list_wrapper')

  MemberData.attachTo(document, {pusher: window.pusher}) if gon.accounts

  CandlestickUI.attachTo('#candlestick')
  SwitchUI.attachTo('#range_switch, #indicator_switch, #main_indicator_switch, #type_switch, #legend_indicator_switch')

  @markets_height = $("[id='market_list']").css("height")

  if gon.markets_pinned == 'false'
    $("[id='market_list']").css("left", "-1px")
    $("[id='market_trades']").css("left", "-1px")
    $("[id='market_list']").css("top", "-1px")
    $("[id='market_trades']").css("top", parseInt(@markets_height, 10) + 3)

    @markets_menu_left = $("[id='market_list_wrapper']").find(".dropdown-wrapper").css("left")
    $("[id='market_list_wrapper']").find(".dropdown-wrapper").css("left", parseInt(@markets_menu_left, 10) - 3)
    @markets_menu_top = $("[id='market_list_wrapper']").find(".dropdown-wrapper").css("top")
    $("[id='market_list_wrapper']").find(".dropdown-wrapper").css("top", parseInt(@markets_menu_top, 10) - 3)

    @trades_menu_left = $("[id='market_trades_wrapper']").find(".dropdown-wrapper").css("left")
    $("[id='market_trades_wrapper']").find(".dropdown-wrapper").css("left", parseInt(@trades_menu_left, 10) - 3)
    @trades_menu_top = $("[id='market_trades_wrapper']").find(".dropdown-wrapper").css("top")
    $("[id='market_trades_wrapper']").find(".dropdown-wrapper").css("top", parseInt(@trades_menu_top, 10) - 3)

    $('left_side_dock').css("background-color", "transparent")
    $('left_side_dock').css("border-color", "transparent")

    $("[href='#left_side_content']").css("right", "-290px")

    $("[id='candlestick']").css("left", "1px")

  window.onresize(null)

  $('.panel-body-content').niceScroll
    autohidemode: true
    cursorborder: "none"


