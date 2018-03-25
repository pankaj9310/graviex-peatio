app.config ($stateProvider, $urlRouterProvider) ->
  $stateProvider
    .state('dividends', {
      url: '/dividends'
      templateUrl: "/templates/dividends/dividends.html"
    })

