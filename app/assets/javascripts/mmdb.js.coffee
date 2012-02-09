@MMDb =
  env: ->
    $('#env').attr 'class'
  development: ->
    @env() == 'development'
  production: ->
    @env() == 'production'
