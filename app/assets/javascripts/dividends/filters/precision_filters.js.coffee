angular.module('precisionFilters', []).filter 'round_down', ->
  (number) ->
    if number == null
      return 0.00000000
    BigNumber(number).round(9, BigNumber.ROUND_DOWN).toF(9)

