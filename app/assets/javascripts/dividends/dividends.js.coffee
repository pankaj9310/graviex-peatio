#= require_tree ./models
#= require_tree ./filters
#= require_self
#= require_tree ./services
#= require_tree ./directives
#= require_tree ./controllers
#= require ./router
#= require ./events

$ ->
  window.pusher_subscriber = new PusherSubscriber()

Member.initData         [gon.current_user]
Product.initData        gon.product
Dividend.initData       gon.dividend
Asset.initData          gon.asset
Interest.initData       gon.interest

window.app = app = angular.module 'dividends', ["ui.router", "ngResource", "translateFilters", "textFilters", "precisionFilters", "smallPrecisionFilters", "ngDialog"]

