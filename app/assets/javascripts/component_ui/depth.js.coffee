@DepthUI = flight.component ->
  @attributes
    chart: '#depths'

  @refresh = (event, data) ->
    chart = @select('chart').highcharts()
#    chart.series[0].setData data.bids.reverse(), false
    chart.series[0].setData data.bids, false
    chart.series[1].setData data.asks, false
#    chart.xAxis[0].setExtremes(data.low, data.high)
    chart.redraw()

  @initChart = (data) ->
    @select('chart').highcharts
      chart:
        margin: 0
        height: 148
        backgroundColor: 'rgba(0,0,0,0)'
        type: 'area'

      title:
        text: ''

      credits:
        enabled: false

      legend:
        enabled: false

      rangeSelector:
        enabled: false

      xAxis: [{
        type: 'logarithmic'
        width: '50%'
        labels:
          enabled: false
      }, {
        type: 'logarithmic'
        offset: 0
        left: '50%'
        labels:
          enabled: false
        width: '50%'
      }]

      yAxis:
        min: 0
        gridLineColor: '#333'
        gridLineDashStyle: 'ShortDot'
        title:
          text: ''
        labels:
          enabled: false

      plotOptions:
        area:
          softThreshold: true
          threshold: 0

      tooltip:
        valueDecimals: 4
        headerFormat:
          """
          <table class=depths-table><tr>
            <th><span>{series.name}</span> #{gon.i18n.chart.price}</th><th>#{gon.i18n.chart.depth}</th>
          </tr>
          """
        pointFormatter: -> 
          '<tr><td>' + this.x.toFixed(9)  + '</td><td>' + this.y.toFixed(1) + '</td></tr>'
        footerFormat: '</table>'
        borderWidth: 0
        backgroundColor: 'rgba(0,0,0,0)'
        borderRadius: 0
        shadow: false
        useHTML: true
        shared: true
        positioner: -> {x: 200, y: 3}

      series : [{
        name : gon.i18n.bid
        fillColor: 'rgba(77, 215, 16, 0.5)'
        lineColor: 'rgb(77, 215, 16)'
        color: 'transparent'
        xAxis: 0
        animation:
          duration: 1000
      },{
        name: gon.i18n.ask
        animation:
          duration: 1000
        fillColor: 'rgba(208, 0, 23, 0.3)'
        lineColor: 'rgb(208, 0, 23)'
        color: 'transparent'
        xAxis: 1
      }]

  @after 'initialize', ->
    @initChart()
    @on document, 'market::depth::response', @refresh
    @on document, 'market::depth::fade_toggle', ->
      @$node.fadeToggle()

    @on @select('close'), 'click', =>
      @trigger 'market::depth::fade_toggle'
