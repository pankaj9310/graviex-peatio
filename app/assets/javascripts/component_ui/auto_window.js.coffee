GUTTER = 2 # linkage to market.css.scss $gutter var
PANEL_TABLE_HEADER_HIGH = 37
PANEL_MARKETS_SEARCH_HIGH = 42
PANEL_PADDING = 8
BORDER_WIDTH = 1
ORDER_BOOK_MIN_HEIGHT = 214
CANDLESTICK_MIN_WIDTH = 685

CANDLESTICK_MIN_HEIGHT = 700
CANDLESTICK_MIN_HEIGHT_SPLIT = 424

TOTAL_MIN_HEIGHT = 850
TOTAL_MIN_HEIGHT_SPLIT = 670
TOTAL_MIN_WIDTH = 1440
TOTAL_MIN_WIDTH_SPLIT = 1356
TOTAL_MIN_WIDTH_PINNED = 1664

@AutoWindowUI = flight.component ->
  @after 'initialize', ->
    gutter = GUTTER
    gutter_2x = GUTTER * 2
    gutter_3x = GUTTER * 3
    gutter_4x = GUTTER * 4
    gutter_5x = GUTTER * 5
    gutter_6x = GUTTER * 6
    gutter_7x = GUTTER * 7
    gutter_8x = GUTTER * 8
    gutter_9x = GUTTER * 9
    panel_table_header_high = PANEL_TABLE_HEADER_HIGH
    panel_markets_search_high = PANEL_MARKETS_SEARCH_HIGH
    order_book_min_height = ORDER_BOOK_MIN_HEIGHT
    candlestick_min_width = CANDLESTICK_MIN_WIDTH
    candlestick_min_height = CANDLESTICK_MIN_HEIGHT
    candlestick_min_height_split = CANDLESTICK_MIN_HEIGHT_SPLIT
    total_min_height = TOTAL_MIN_HEIGHT
    total_min_height_split = TOTAL_MIN_HEIGHT_SPLIT
    total_min_width = TOTAL_MIN_WIDTH
    total_min_width_pinned = TOTAL_MIN_WIDTH_PINNED
    total_min_width_split = TOTAL_MIN_WIDTH_SPLIT

    @$node.resize ->
      navbar_h       = $('.navbar').height() + BORDER_WIDTH
      markets_h      = $('#market_list').height() + 2*BORDER_WIDTH
      entry_h        = $('#ask_entry').height() + 2*BORDER_WIDTH
      depths_h       = $('#depths_wrapper').height() + 2*BORDER_WIDTH
      my_orders_h    = $('#my_orders').height() + 2*BORDER_WIDTH
      ticker_h       = $('#ticker').height() + 2*BORDER_WIDTH

      content_min_width = total_min_width_split

      # ----------------------
      # Define total min width
      if gon.markets_pinned == 'true'
        total_min_width = total_min_width_pinned
        content_min_width = total_min_width_pinned

      $("#markets-show").css("min-width", content_min_width)
      $("#wrap").find(".content").css("min-width", content_min_width)

      # ---------------------
      # Adjust heights first. Because scrollbar may be removed after heights
      # adjustment, window width will be affected.
      window_h = $(@).height()
      $('.content').height(window_h - navbar_h)

      current_min_height = total_min_height
      order_h = order_book_min_height
      $('#order_book').css("min-height", order_book_min_height)

      # ----------------------
      # If width is below TOTAL_MIN_WIDTH
      need_rearrange = false
      if window.innerWidth <= total_min_width || window.innerHeight < total_min_height_split || (window.innerHeight >= total_min_height_split && window.innerHeight < total_min_height && window.innerWidth > total_min_width)
        $('#my_orders').css("min-height", 206)
        $('#my_orders').css("height", 206)
        my_orders_h = $('#my_orders').height()
        order_h = window_h - navbar_h - depths_h - my_orders_h - ticker_h - gutter_6x - 2*BORDER_WIDTH
        current_min_height = total_min_height_split
        need_rearrange = true
      else
        $('#my_orders').css("min-height", 180)
        $('#my_orders').css("height", 180)
        my_orders_h = $('#my_orders').height()
        order_h = window_h - navbar_h - entry_h - depths_h - my_orders_h - ticker_h - gutter_6x - 2*BORDER_WIDTH

      if order_h < order_book_min_height
        order_h = order_book_min_height

      # -----------
      # Positioning
      $('#order_book').css("min-height", order_book_min_height)
      $('#order_book').height(order_h)
      $('#order_book .panel-body-content').height(order_h - panel_table_header_high - 2*PANEL_PADDING)

      $('#ticker').css("top", order_h + gutter_3x)
      $('#depths_wrapper').css("top", order_h + ticker_h + gutter_4x)
      $('#my_orders').css("top", order_h + ticker_h + depths_h + gutter_5x)

      # -------------
      # Adjust widths
      window_w = window.innerWidth
      markets_w    = $('#market_list').width()
      order_book_w = $('#order_book').width()
      $('#market_list .panel panel-default').width(markets_w)

      if gon.markets_pinned == 'false'
        $('#candlestick').width(window_w - order_book_w - gutter_2x - 20)
      else
        $('#candlestick').width(window_w - order_book_w - markets_w - gutter_4x - 20)

      $('#candlestick').css("min-width", candlestick_min_width)
      $('#candlestick').height(window_h - navbar_h - gutter_3x)

      # ----------------------
      # If width is below TOTAL_MIN_WIDTH
      if need_rearrange # window.innerWidth <= total_min_width || window.innerHeight < total_min_height_split || (window.innerHeight >= total_min_height_split && window.innerHeight < total_min_height && window.innerWidth > total_min_width)
        $('#candlestick').css("min-height", candlestick_min_height_split)
        $('#candlestick').css("height", $('#candlestick').height() - $('.entry-left').height() - gutter_2x)
 
        $('.entry-right').css("left", ($('#candlestick').position().left + $('#candlestick').width() / 2) - ($('.entry-right').width()))
        $('.entry-right').css("top", $('#candlestick').height() + gutter_3x)

        $('.entry-left').css("left", $('.entry-right').position().left + $('.entry-right').width() + gutter_2x)
        $('.entry-left').css("top", $('#candlestick').height() + gutter_3x)

        $('#my_orders_wrapper').find(".dropdown-wrapper").css("top", $('#candlestick').height() + gutter_3x) # 24
      else
        if window.innerHeight >= total_min_height_split
          $('#candlestick').css("min-height", candlestick_min_height)

#          $('.entry-left').css("left", $('#my_orders').position().left + gutter_2x + $('.entry-right').width())
          $('.entry-left').css("left", "")
          $('.entry-left').css("right", 2)
          $('.entry-left').css("top", order_h + ticker_h + depths_h + my_orders_h + gutter_7x)

#          $('.entry-right').css("left", $('#my_orders').position().left)
          $('.entry-right').css("left", "")
          $('.entry-right').css("right", $('.entry-left').width() + gutter_2x + 2)
          $('.entry-right').css("top", order_h + ticker_h + depths_h + my_orders_h + gutter_7x)

#          $('#my_orders_wrapper').find(".dropdown-wrapper").css("bottom", 204)
          $('#my_orders_wrapper').find(".dropdown-wrapper").css("top", $('#depths_wrapper').position().top + $('#depths_wrapper').height() + gutter_2x)

      # ---------------
      # Post processing
      if true #window.innerHeight >= total_min_height_split
        window_h_syntetic = navbar_h + $('#candlestick').height() + $('.entry-left').height() + gutter_4x

        if !need_rearrange
          window_h_syntetic = navbar_h + $('#candlestick').height() + gutter_3x

        markets_h = (window_h_syntetic - navbar_h) / 2
        markets_inner_h = markets_h - (panel_table_header_high + panel_markets_search_high)
        $('#market_list').css("min-height", markets_h)
        $('#market_list').height(markets_h)
        $('#market_list').find(".panel-default").css("min-height", markets_h)
        $('#market_list').find(".panel-default").height(markets_h)
        $('#market_list').find(".panel-body-content").css("min-height", markets_inner_h)
        $('#market_list').find(".panel-body-content").height(markets_inner_h-16)

        markets_h = $('#market_list').height() + 2*BORDER_WIDTH

        trades_h = window_h_syntetic - navbar_h - markets_h - gutter_2x - 2*BORDER_WIDTH
        trades_top = markets_h + 2*BORDER_WIDTH

        if gon.markets_pinned == 'true'
          trades_top += 2

        $('#market_trades').css("top", trades_top)
        $('#market_trades').height(trades_h)
        $('#market_trades .panel').height(trades_h - 2*BORDER_WIDTH)
        $('#market_trades .panel-body-content').height(trades_h - 2*BORDER_WIDTH - panel_table_header_high - 2*PANEL_PADDING)

        $("[href='#left_side_content']").css("right", 200 - ((window_h_syntetic - navbar_h)/2 + 70/2))

      if gon.markets_pinned == 'true'
        $('#market_trades_wrapper').find(".dropdown-wrapper").css("top", trades_top + panel_table_header_high)
      else
        $('#market_trades_wrapper').find(".dropdown-wrapper").css("top", trades_top + panel_table_header_high + 35)

    @$node.resize()
