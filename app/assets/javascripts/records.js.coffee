# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $(".part_name_select").on "change", ->
    $.ajax
      url: "/records/narrow_choices"
      type: "GET"
      dataType: "script"
      data:
        product_choice: $('.part_name_select option:selected').val()