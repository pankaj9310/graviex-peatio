app.controller 'IntradayController', ($scope, $stateParams, $http) ->
  ctrl = @
  @list = gon.intraday_list

  @noRecords = ->
    @list.length == 0

  @refresh = ->
    @list = gon.intraday_list
    $scope.$apply()

  do @event = ->
    Dividend.bind "create update destroy", ->
      ctrl.refresh()
