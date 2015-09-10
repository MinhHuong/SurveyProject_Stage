# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

check_filter_criteria = ->
  filter_code = $('#filter-code').text()
  $('#filter_form').find('input[type=radio]').each (index, value) ->
    if $(value).attr('value') == filter_code
      $(value).prop('checked', true)

$ ->
  check_filter_criteria()

  $('#form-questions').submit ->
    isValid = true
    $(this).find('.question').each (index, value) ->
      if $(value).find('input').length != 0
        valid = $(value).find('input').is(':checked')
        isValid = isValid and valid
        if not valid
          $(value).find('.validation-zone').css('visibility', 'visible')
        else
          $(value).find('.validation-zone').css('visibility', 'hidden')
    return isValid

  return