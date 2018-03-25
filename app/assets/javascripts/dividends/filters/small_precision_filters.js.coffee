angular.module('smallPrecisionFilters', []).filter 'round_down_small', ->
  (number) ->
    if number == null
      return 0.0000
    BigNumber(number).round(4, BigNumber.ROUND_DOWN).toF(4)

