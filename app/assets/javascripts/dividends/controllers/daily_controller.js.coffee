app.controller 'DailyController', ($scope, $stateParams, $http) ->
  ctrl = @
  @list = gon.daily_list

  @noRecords = ->
    @list.length == 0

  @refresh = ->
    @list = gon.daily_list
    $scope.$apply()

  do @event = ->
    Dividend.bind "create update destroy", ->
      ctrl.refresh()
