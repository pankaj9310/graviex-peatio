if gon.local is "zh-CN"
  DATETIME_LABEL_FORMAT_FOR_TOOLTIP =
    millisecond: ['%m月%e日, %H:%M:%S.%L', '%m月%e日, %H:%M:%S.%L', '-%H:%M:%S.%L']
    second:      ['%m月%e日, %H:%M:%S', '%m月%e日, %H:%M:%S', '-%H:%M:%S']
    minute:      ['%m月%e日, %H:%M', '%m月%e日, %H:%M', '-%H:%M']
    hour:        ['%m月%e日, %H:%M', '%m月%e日, %H:%M', '-%H:%M']
    day:         ['%m月%e日, %H:%M', '%m月%e日, %H:%M', '-%H:%M']
    week:        ['%Y年%m月%e日', '%Y年%m月%e日', '-%m月%e日']
    month:       ['%Y年%m月', '%Y年%m月', '-%m']
    year:        ['%Y', '%Y', '-%Y']

DATETIME_LABEL_FORMAT =
  second: '%H:%M:%S'
  minute: '%H:%M'
  hour: '%H:%M'
  day: '%m-%d'
  week: '%m-%d'
  month: '%Y-%m'
  year: '%Y'

RANGE_DEFAULT =
  fill: 'none',
  stroke: 'none',
  'stroke-width': 0,
  r: 8,
  style:
    color: '#333',
  states:
    hover:
      fill: '#000',
      style:
        color: '#ccc'
    select:
      fill: '#000',
      style:
        color: '#eee'

COLOR_ON =
  candlestick:
    color: '#990f0f'
    upColor: '#116d0d'
    lineColor: '#cc1414'
    upLineColor: '#49c043'
  close:
    color: null

# The trick is use invalid color code to make the line transparent
COLOR_OFF =
  candlestick:
    color: 'invalid'
    upColor: 'invalid'
    lineColor: 'invalid'
    upLineColor: 'invalid'
  close:
    color: 'invalid'

COLOR = {
  candlestick: _.extend({}, COLOR_OFF.candlestick),
  close: _.extend({}, COLOR_OFF.close)
}

INDICATOR = {MA: false, EMA: false, OFF: false}
MACD_INDICATOR = {MACD: false, OFF: false}
SIG_INDICATOR = {SIG: false, OFF: false}
HIST_INDICATOR = {HIST: false, OFF: false}
LEGEND_INDICATOR = {Legend: false, OFF: false}

VOLUME_IDX = 0
MA5_IDX = 1
MA10_IDX = 2
EMA7_IDX = 3
EMA30_IDX = 4
MACD_IDX = 5 
SIG_IDX = 6 
HIST_IDX = 7
CANDLESTICK_IDX = 8
CLOSE_IDX = 9

@CandlestickUI = flight.component ->
  @mask = ->
    @$node.find('.mask').show()

  @unmask = ->
    @$node.find('.mask').hide()

  @request = ->
    @mask()

  @init = (event, data) ->
    @running = true
    @$node.find('#candlestick_chart').highcharts()?.destroy()

    @initHighStock(data)
    @adjustChart()
    @trigger 'market::candlestick::created', data

  @switchType = (event, data) ->
    _.extend(COLOR[key], COLOR_OFF[key]) for key, val of COLOR
    _.extend(COLOR[data.x], COLOR_ON[data.x])

    if chart = @$node.find('#candlestick_chart').highcharts()
      for type, colors of COLOR
        for s in chart.series
          if !s.userOptions.algorithm? && (s.userOptions.id == type)
            s.update(colors, false)
      @trigger "switch::main_indicator_switch::init"

  @switchMainIndicator = (event, data) ->
    INDICATOR[key] = false for key, val of INDICATOR
    INDICATOR[data.x] = true

    if chart = @$node.find('#candlestick_chart').highcharts()
      for s in chart.series
        if s.userOptions.innerGroup == 'main'
          s.setVisible(true, false)

      for indicator, visible of INDICATOR
        for s in chart.series
          if s.userOptions.algorithm? && (s.userOptions.algorithm == indicator)
            s.setVisible(visible, false)
      chart.redraw()

  @adjustChart = () ->
    #console.log('adjustChart', MACD_INDICATOR['MACD'])
    if chart = @$node.find('#candlestick_chart').highcharts()

      if MACD_INDICATOR['MACD']
        chart.yAxis[2].update({
          height: "15%",
          top: "85%"
        })
        chart.yAxis[1].update({
          height: "15%"
          top: "70%"
        })
        chart.yAxis[0].update({
          height: "70%"
        })
      else
        chart.yAxis[2].update({
          height: "0%"
        })
        chart.yAxis[1].update({
          height: "15%"
          top: "85%"
        })
        chart.yAxis[0].update({
          height: "85%"
        })
      chart.redraw()

  @switchMACDIndicator = (event, data) ->
    MACD_INDICATOR[key] = false for key, val of MACD_INDICATOR
    MACD_INDICATOR[data.x] = true

    if chart = @$node.find('#candlestick_chart').highcharts()
      for s in chart.series
        if s.userOptions.innerGroup == 'macd'
          s.setVisible(MACD_INDICATOR['MACD'], false)
          @adjustChart()
      #chart.redraw()

  @switchLegendIndicator = (event, data) ->
    LEGEND_INDICATOR[key] = false for key, val of LEGEND_INDICATOR
    LEGEND_INDICATOR[data.x] = true

#    #console.log(event, data)
#    if chart = @$node.find('#candlestick_chart').highcharts()
#      chart.tooltip.enabled = LEGEND_INDICATOR['Legend']

  @default_range = (unit) ->
    1000 * 60 * unit * 100

  @initHighStock = (data, tooltipEnabled) ->
    component = @
    range = @default_range(data['minutes'])
    unit = $("[data-unit=#{data['minutes']}]").text()
    title = "#{gon.market.base_unit.toUpperCase()}/#{gon.market.quote_unit.toUpperCase()} - #{unit}"

    timeUnits =
      millisecond: 1
      second: 1000
      minute: 60000
      hour: 3600000
      day: 24 * 3600000
      week: 7 * 24 * 3600000
      month: 31 * 24 * 3600000
      year: 31556952000

    dataGrouping =
      enabled: false

    tooltipTemplate = JST["templates/tooltip"]

    if DATETIME_LABEL_FORMAT_FOR_TOOLTIP
        dataGrouping['dateTimeLabelFormats'] = DATETIME_LABEL_FORMAT_FOR_TOOLTIP

    @$node.find('#candlestick_chart').highcharts "StockChart",
      chart:
        events:
          load: =>
            @unmask()
        animation: true
        marginTop: 95
        backgroundColor: 'rgba(0,0,0, 0.0)'

      mapNavigation:
        enableMouseWheelZoom: true

      credits:
        enabled: false

      tooltip:
        enabled: true
#        crosshairs: [{
#            width: 0.5,
#            dashStyle: 'solid',
#            color: '#777'
#        }, false],
        valueDecimals: gon.market.bid.fixed
        borderWidth: 0
        backgroundColor: 'rgba(0,0,0,0)'
        borderRadius: 2
        shadow: false
        shared: true
        split: false
        positioner: (w, h, point) ->
          chart_w = $(@chart.renderTo).width()
          chart_h = $(@chart.renderTo).height()
          grid_h  = Math.min(20, Math.ceil(chart_h/10))
          # x = Math.max(10, point.plotX-w-20)
          # y = Math.max(0, Math.floor(point.plotY/grid_h)*grid_h-20)

#          if LEGEND_INDICATOR['Legend'] == true && window.innerWidth > 1600
#            x = 5
#          else
#            x = -800
#            this.hide()

          if LEGEND_INDICATOR['Legend'] == true
            x = 5
          else
            x = -800
            this.hide()

#          console.log(this)

          y = 5
          x: x, y: y
        useHTML: true
        formatter: ->
          chart  = @points[0].series.chart
          series = @points[0].series
          index  = @points[0].point.index
          key    = @points[0].key

          for k, v of timeUnits
            if v >= series.xAxis.closestPointRange || (v <= timeUnits.day && key % v > 0)
              dateFormat = dateTimeLabelFormats = series.options.dataGrouping.dateTimeLabelFormats[k][0]
              title = Highcharts.dateFormat dateFormat, key
              break

          fun = (h, s) ->
            h[s.options.id] = s.data[index]
            h
          tooltipTemplate
            title:  title
            indicator: INDICATOR
            macd_indicator: MACD_INDICATOR
            format: (v, fixed=3) -> formatter.fixPriceGroup parseFloat(v)
            format4: (v, fixed=4) -> 
              if fixed > 4 
                formatter.round(v, 4) 
              else
                formatter.round(v, fixed)
            points: _.reduce chart.series, fun, {}

      plotOptions:
        candlestick:
          turboThreshold: 0
          followPointer: true
          color: '#990f0f'
          upColor: '#000000'
          lineColor: '#cc1414'
          upLineColor: '#49c043'
          dataGrouping: dataGrouping
        column:
          turboThreshold: 0
          dataGrouping: dataGrouping
        trendline:
          lineWidth: 1
        histogram:
          lineWidth: 1
          tooltip:
            pointFormat:
              """
              <li><span style='color: {series.color};'>{series.name}: <b>{point.y}</b></span></li>
              """

      scrollbar:
        buttonArrowColor: '#333'
        barBackgroundColor: '#202020'
        buttonBackgroundColor: '#202020'
        trackBackgroundColor: '#202020'
        barBorderColor: '#2a2a2a'
        buttonBorderColor: '#2a2a2a'
        trackBorderColor: '#2a2a2a'

      rangeSelector:
        enabled: false

      navigator:
        maskFill: 'rgba(32, 32, 32, 0.6)'
        outlineColor: '#333'
        outlineWidth: 1
        baseSeries: 'candlestick'
        series:
          color: '#306196'
        xAxis:
          dateTimeLabelFormats: DATETIME_LABEL_FORMAT

      xAxis:
        type: 'datetime',
        dateTimeLabelFormats: DATETIME_LABEL_FORMAT
        lineColor: '#333'
        tickColor: '#333'
        tickWidth: 2
        range: range
        maxPadding: 1
        crosshair:
          snap: false
          width: 0.5
          dashStyle: 'solid'
          color: '#777'
          interpolate: true
          label:
            enabled: true
            formatter: (val) ->
              Highcharts.dateFormat('%a %d %b %H:%M:%S', val)
            backgroundColor: '#2b3434'
            style:
              color: '#aaa'
        events:
          afterSetExtremes: (e) ->
            if e.trigger == 'navigator' && e.triggerOp == 'navigator-drag'
              if component.liveRange(@.chart) && !component.running
                component.trigger "switch::range_switch::init"

      yAxis: [
        {
          labels:
            enabled: true
            align: 'left'
            reserveSpace: true
            formatter: -> formatter.fixPriceGroup @.value
            x: 2
            y: -5
#            zIndex: -7
#            format: '{value:.9f}'
          gridLineColor: '#222'
          gridLineDashStyle: 'ShortDot'
          top: "0%"
          height: "85%"
          lineColor: '#fff'
#          minRange: if gon.ticker.last then parseFloat(gon.ticker.last)/25 else null
          min: null
#          softMin: 0.000000000
#          startOnTick: false
          tickPositioner: ->
            maxDeviation = this.dataMax - this.dataMin
            dataMin = this.dataMin
            dataMax = this.dataMax
            ticks = 10.0
            threshold = 0.000000010
            if maxDeviation <= threshold
              maxDeviation = threshold
              
              if dataMin - maxDeviation / 2.0 < 0.000000000
                dataMin = 0.000000000 
              else
                if dataMin + threshold > dataMax
                  dataMin -= (((dataMin + threshold) - dataMax) / 2.0)

            step = maxDeviation / ticks
            tickArray = []
 
            #console.log "diff=#{maxDeviation}, step=#{step}, minRange=#{this.minRange}"

            prevTick = 0.000000000
            currentTick = dataMin
            for i in [0..ticks]
              if currentTick - prevTick >= 0.0000000005
                #console.log "tick(#{i})=#{currentTick}"
                tickArray.push(currentTick)
                prevTick = currentTick
              currentTick += step
            return tickArray

          crosshair:
            snap: false
            interpolate: true
            width: 0.5
            dashStyle: 'solid'
            color: '#777'
            label:
              enabled: true
              formatter: (v) -> formatter.fixPriceGroup parseFloat(v)
              backgroundColor: '#2b3434'
              style:
                color: '#aaa'
        }
        {
          labels:
            enabled: true
            align: 'left'
#            reserveSpace: false
            x: -73
            y: -5
          top: "85%"
          gridLineColor: '#222'
          gridLineDashStyle: 'ShortDot'
#          gridLineColor: '#000'
          height: "15%"
          crosshair:
            snap: false
            width: 0.5
            dashStyle: 'solid'
            color: '#777'
            label:
              enabled: true
              format: '{value:.4f}'
              backgroundColor: '#2b3434'
              style:
                color: '#aaa'
        }
        {
          labels:
            enabled: false
          top: "85%"
          gridLineColor: '#000'
          height: "0%"
        }
      ]

      series: [
        {
          id: 'volume'
          name: gon.i18n.chart.volume
          yAxis: 1
          type: "column"
          data: data['volume']
          color: '#777'
          showInLegend: false
        }
        {
          id: 'ma5'
          name: 'MA5',
          linkedTo: 'close',
          innerGroup: 'main',
          showInLegend: true,
          type: 'trendline',
          algorithm: 'MA',
          periods: 5
          color: '#7c9aaa'
          visible: INDICATOR['MA']
          zIndex: 1
          marker:
            radius: 0
        }
        {
          id: 'ma10'
          name: 'MA10'
          linkedTo: 'close',
          innerGroup: 'main',
          showInLegend: true,
          type: 'trendline',
          algorithm: 'MA',
          periods: 10
          color: '#be8f53'
          visible: INDICATOR['MA']
          zIndex: 2
          marker:
            radius: 0
        }
        {
          id: 'ema7'
          name: 'EMA7',
          linkedTo: 'close',
          innerGroup: 'main',
          showInLegend: true,
          type: 'trendline',
          algorithm: 'EMA',
          periods: 7
          color: '#7c9aaa'
          visible: INDICATOR['EMA']
          zIndex: 3
          marker:
            radius: 0
        }
        {
          id: 'ema30'
          name: 'EMA30',
          linkedTo: 'close',
          innerGroup: 'main',
          showInLegend: true,
          type: 'trendline',
          algorithm: 'EMA',
          periods: 30
          color: '#be8f53'
          visible: INDICATOR['EMA']
          zIndex: 4
          marker:
            radius: 0
        }
        {
          id: 'macd'
          name : 'MACD',
          linkedTo: 'close',
          innerGroup: 'macd',
          yAxis: 2,
          showInLegend: true,
          type: 'trendline',
          algorithm: 'MACD'
          color: '#7c9aaa'
          visible: MACD_INDICATOR['MACD']
          zIndex: 5
          marker:
            radius: 0
        }
        {
          id: 'sig'
          name : 'SIG',
          linkedTo: 'close',
          innerGroup: 'macd',
          yAxis: 2,
          showInLegend: true,
          type: 'trendline',
          algorithm: 'signalLine'
          color: '#be8f53'
          visible: MACD_INDICATOR['MACD']
          zIndex: 6
          marker:
            radius: 0
        }
        {
          id: 'hist'
          name: 'HIST',
          linkedTo: 'close',
          innerGroup: 'macd',
          yAxis: 2,
          showInLegend: true,
          type: 'histogram'
          visible: MACD_INDICATOR['MACD']
          zIndex: 7
          color: '#990f0f'
        }
        _.extend({
          id: 'candlestick'
          name: gon.i18n.chart.candlestick
          type: "candlestick"
          data: data['candlestick']
          showInLegend: false
          zIndex: 0
        }, COLOR['candlestick']),
        _.extend({
          id: 'close'
          type: 'spline'
          data: data['close']
          showInLegend: false
          marker:
            radius: 0
        }, COLOR['close']),
      ]

  @formatPointArray = (point) ->
    x: point[0], open: point[1], high: point[2], low: point[3], close: point[4]

  @createPointOnSeries = (chart, i, px, point) ->
    chart.series[i].addPoint(point, false, true)
#    chart.series[i].data.push(point)
#    last = chart.series[i].points[chart.series[i].points.length-1]
#    console.log "Add point on #{i}: px=#{px} lastx=#{last.x} count=#{chart.series[i].points.length-1}", point

  @createPoint = (chart, data, i) ->
    @createPointOnSeries(chart, CANDLESTICK_IDX, data.candlestick[i][0], data.candlestick[i])
    @createPointOnSeries(chart, CLOSE_IDX, data.close[i][0], data.close[i])
    @createPointOnSeries(chart, VOLUME_IDX, data.volume[i].x, data.volume[i])
    chart.redraw(true)

  @updatePointOnSeries = (chart, i, px, point) ->
    if chart.series[i].points
      last = chart.series[i].points[chart.series[i].points.length-1]
      if px == last.x
        last.update(point, true)
#        console.log "Update point on #{i}: px=#{px} lastx=#{last.x}", point
      else
        console.log "Error update on series #{i}: px=#{px} lastx=#{last.x}"

  @updatePoint = (chart, data, i) ->
    @updatePointOnSeries(chart, CANDLESTICK_IDX, data.candlestick[i][0], data.candlestick[i])
    @updatePointOnSeries(chart, CLOSE_IDX, data.close[i][0], data.close[i][1])
    @updatePointOnSeries(chart, VOLUME_IDX, data.volume[i].x, data.volume[i])
    chart.redraw(true)

  @process = (chart, data) ->
    for i in [0..(data.candlestick.length-1)]
      current = chart.series[CANDLESTICK_IDX].points.length - 1
      current_point = chart.series[CANDLESTICK_IDX].points[current]

      if data.candlestick[i][0] > current_point.x
        @createPoint chart, data, i
      else
        @updatePoint chart, data, i

  @updateByTrades = (event, data) ->
    chart = @$node.find('#candlestick_chart').highcharts()

    if @liveRange(chart)
      @process(chart, data)
    else
      @running = false

  @liveRange = (chart) ->
#    p1 = chart.series[CANDLESTICK_IDX].points[ chart.series[CANDLESTICK_IDX].points.length-1 ].x
#    p2 = chart.series[10].points[ chart.series[10].points.length-1 ].x
#    p1 == p2
    return true

  @after 'initialize', ->
    @on document, 'market::candlestick::request', @request
    @on document, 'market::candlestick::response', @init
    @on document, 'market::candlestick::trades', @updateByTrades
    @on document, 'switch::legend_indicator_switch', @switchLegendIndicator
    @on document, 'switch::main_indicator_switch', @switchMainIndicator
    @on document, 'switch::indicator_switch', @switchMACDIndicator
    @on document, 'switch::type_switch', @switchType


