#= require bootstrap
#= require bootstrap-switch.min

app.directive 'accounts', ->
  return {
    restrict: 'E'
    templateUrl: '/templates/funds/accounts.html'
    scope: { localValue: '=accounts' }
    controller: ($scope, $state) ->
      ctrl = @
      @state = $state
      @initial_state = false

      $scope.accounts = Account.select (item) ->
        return (parseFloat(item.balance) + parseFloat(item.locked) > 0.0000000001)
      
      if $scope.accounts.length == 0
        $scope.accounts = Account.all()
        @initial_state = true

      if window.location.hash == ""
        @state.transitionTo("deposits.currency", {currency: $scope.accounts[0].currency})

      $('input[name="showall-checkbox"]').bootstrapSwitch
        labelText: 'Empty'
        state: @initial_state
        handleWidth: 70
        labelWidth: 70
        onSwitchChange: (event, state) ->
          if state
            $scope.accounts = Account.all()
          else
            $scope.accounts = Account.select (item) ->
              return (parseFloat(item.balance) + parseFloat(item.locked) > 0.0000000001)
          $scope.$apply()

      # Might have a better way
      @selectedCurrency = window.location.hash.split('/')[2] || $scope.accounts[0].currency
      @currentAction = window.location.hash.split('/')[1] || 'deposits'

      $scope.currency = @selectedCurrency

      @isSelected = (currency) ->
        @selectedCurrency == currency

      @isDeposit = ->
        @currentAction == 'deposits'

      @isWithdraw = ->
        @currentAction == 'withdraws'

      @deposit = (account) ->
        ctrl.state.transitionTo("deposits.currency", {currency: account.currency})
        ctrl.selectedCurrency = account.currency
        ctrl.currentAction = "deposits"

      @withdraw = (account) ->
        ctrl.state.transitionTo("withdraws.currency", {currency: account.currency})
        ctrl.selectedCurrency = account.currency
        ctrl.currentAction = "withdraws"

      do @event = ->
        Account.bind "create update destroy", ->
          $scope.$apply()

    controllerAs: 'accountsCtrl'
  }

