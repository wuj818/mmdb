$ ->
  $graph = $('#movie-history-line-graph')

  if $graph.length isnt 0
    data = $graph.data 'graph-data'

    nv.addGraph ->
      chart = nv.models.lineChart()
        .useInteractiveGuideline(true)
        .color(d3.scale.category10().range())
        .margin(left: 65, right: 30, top: 10)
        .yDomain([0, $graph.data 'y-max'])
        .clipEdge false

      chart.xAxis.tickFormat d3.format 'd'

      chart.yAxis.tickFormat d3.format '.02f'

      d3.select("##{$graph.attr 'id'} svg")
        .datum(data)
        .transition()
        .duration(500)
        .call chart

      nv.utils.windowResize chart.update

      chart
