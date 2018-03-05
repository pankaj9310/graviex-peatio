@PlaceOrderData = flight.component ->

  @onInput = (event, data) ->
    {input: @input, known: @known, output: @output} = data.variables
    @order[@input] = data.value

#    console.log "onInput: ", data, @order, @input, @known

    return unless @order[@input] && @order[@known]
    @trigger "place_order::output::#{@output}", @order

  @onReset = (event, data) ->
    {input: @input, known: @known, output: @output} = data.variables
    @order[@input] = @order[@output] = null

    @trigger "place_order::reset::#{@output}"
    @trigger "place_order::order::updated", @order

  @onUpdateOrder = (event, data) ->
    @order = data

  @after 'initialize', ->
    @order = {price: null, volume: null, total: null}

    @on 'place_order::input', @onInput
    @on 'place_order::reset', @onReset
    @on 'place_order::order::total', @onUpdateOrder
