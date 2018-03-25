$(window).load ->

  # flash message
  $.subscribe 'flash', (event, data) ->
    $('.flash-messages').show()
    $('#flash-content').html(data.message)
    setTimeout(->
      $('.flash-messages').hide(1000)
    , 10000)

  # init the two factor auth
  $.subscribe 'two_factor_init', (event, data) ->
    TwoFactorAuth.attachTo('.two-factor-auth-container')

  $.publish 'two_factor_init'
