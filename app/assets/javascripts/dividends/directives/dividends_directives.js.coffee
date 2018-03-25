#= require bootstrap
#= require bootstrap-switch.min

app.directive 'dividends', ->
  return {
    restrict: 'E'
    templateUrl: '/templates/dividends/dividends.html'
    scope: { localValue: '=dividends' }
    controller: ($scope, $state, $http, $filter, $gon, ngDialog) ->
      console.log Product.all()[0]

      ctrl = @
      @state = $state
     
      $scope.product = Product.all()[0]
      $scope.dividend = Dividend.all()[0]
      $scope.asset = Asset.all()[0]
      $scope.interest = Interest.all()[0]
      $scope.interest_intraday = gon.interest_intraday
      $scope.interest_total = gon.interest_total
      $scope.error = false

      if $scope.dividend.aasm_state == 'accepted'
        $('div[name="product-panel"]').removeClass('hide')
      else
        $('div[name="product-panel"]').addClass('hide')

      $('input[name="sign-checkbox"]').bootstrapSwitch
        labelText: 'Signed'
        state: $scope.dividend.aasm_state == 'accepted'
        onText: 'YES'
        offText: 'NO'
        onSwitchChange: (event, state) ->
          if $scope.error
            $scope.error = false
            return

          if state
            $scope.acceptAgreement(event)
          else
            $scope.revokeAgreement(event)

          $scope.$apply()

      $scope.acceptAgreement = (event) ->
        $http.post("/dividends/accept_agreement", {})
          .error (responseText) ->
            $scope.error = true
            $.publish 'flash', {message: responseText.errors }
          .finally ->
            if !$scope.error 
              $('div[name="product-panel"]').removeClass('hide')
            if $scope.error
              $('input[name="sign-checkbox"]').bootstrapSwitch('state', false);

      $scope.revokeAgreement = (event) ->
        $http.post("/dividends/revoke_agreement", {})
          .error (responseText) ->
            $scope.error = true
            $.publish 'flash', {message: responseText.errors }
          .finally ->
            if !$scope.error 
              $('div[name="product-panel"]').addClass('hide')
            if $scope.error
              $('input[name="sign-checkbox"]').bootstrapSwitch('state', true);

      do @event = ->
        Dividend.bind "create update destroy", ->
          $scope.$apply()

    controllerAs: 'dividendsCtrl'
  }

