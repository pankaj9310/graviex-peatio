@OrderTotalUI = flight.component ->
  flight.compose.mixin @, [OrderInputMixin]

  @attributes
    precision: gon.market.bid.fixed
    variables:
      input: 'total'
      known: 'price'
      output: 'volume'

  @onOutput = (event, order) ->
    total = order.price.times order.volume

    @changeOrder @value unless @validateRange(total)
    @setInputValue @value

    @fee = 0.0
    if event.target.id == 'ask_entry'
      @fee = gon.market.ask.fee
    else
      @fee = gon.market.bid.fee

    order.total = @value
    order.fee = @value * @fee
    @trigger 'place_order::order::updated', order
    console.log(event.target.id, order)
