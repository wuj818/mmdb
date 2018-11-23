$(document).on 'turbolinks:load', ->
  if gtag?
    property_id = $('#google-analytics').data 'property-id'
    page_path = window.location.pathname + window.location.search

    gtag 'config', property_id, { 'page_path': page_path }
