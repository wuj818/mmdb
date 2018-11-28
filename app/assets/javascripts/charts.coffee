$(document).on 'turbolinks:load', ->
  Highcharts.setOptions
    lang:
      thousandsSep: ','
    credits:
      enabled: false
    chart:
      zoomType: 'x'
    title:
      text: null
    xAxis:
      title:
        text: null
    yAxis:
      title:
        text: null
    tooltip:
      shared: true
      crosshairs: true
    plotOptions:
      line:
        marker:
          enabled: false
      area:
        marker:
          enabled: false
        stacking: 'normal'

  $('.chart').each ->
    id = $(@).attr 'id'
    options = $(@).data().options

    Highcharts.chart id, options
