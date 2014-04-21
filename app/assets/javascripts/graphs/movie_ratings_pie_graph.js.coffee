$ ->
  $graph = $('#movie-ratings-pie-graph')

  if $graph.length isnt 0
    data = $graph.data 'graph-data'
    total = $graph.data 'total'

    nv.addGraph ->
      chart = nv.models.pieChart()
        .color(d3.scale.category10().range())
        .x( (d) -> d.label )
        .y( (d) -> d.value )

      chart.tooltipContent (key, y, e, graph) ->
        count = parseInt y
        percentage = count / total * 100
        "<h3>#{key}</h3><p>#{count} (#{percentage.toFixed 2}%)</p>"

      d3.select("##{$graph.attr 'id'} svg")
        .datum(data)
        .transition()
        .duration(500)
        .call chart

      nv.utils.windowResize chart.update

      chart
