# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

check_filter_criteria = ->
  filter_code = $('#filter-code').text()
  $('#filter_form').find('input[type=radio]').each (index, value) ->
    if $(value).attr('value') == filter_code
      $(value).prop('checked', true)

current_page = 1
total_page = 0

show_current_page = ->
  if current_page == 1
    $('#btn-submit').css('visibility', 'hidden')
    $('#btn-prev').css('visibility','hidden')
  else if current_page == total_page
    $('#btn-next').css('visibility', 'hidden')
    $('#btn-submit').css('visibility', 'visible')
  else
    $('#btn-submit').css('visibility', 'hidden')
    $('#btn-prev').css('visibility', 'visible')
    $('#btn-next').css('visibility', 'visible')

  ratio = Math.floor(current_page/total_page * 100)
  $('#progress-questions')
  .css('width', ratio + '%')
  .attr('aria-valuenow', ratio)
  $('#progress-percent').text(ratio + '% Complete' )

  $('.question').hide()
  $('#question' + current_page).fadeIn()
  return

validate_question = ->
  valid = true
  current_question = $('#question' + current_page)
  if $(current_question).find('input').length != 0
    if $(current_question).find('input').is(':checked')
      $(current_question).find('.validation-zone').css('visibility', 'hidden')
    else
      $(current_question).find('.validation-zone').css('visibility', 'visible')
      valid = false
  return valid

$ ->
  check_filter_criteria()

  total_page = $('.question').length
  show_current_page()

  $('#btn-prev').click (event) ->
    event.preventDefault()
    if current_page > 1 then current_page -=1
    show_current_page()

  $('#btn-next').click (event) ->
    event.preventDefault()
    valid = validate_question()
    if valid
      if current_page < total_page then current_page += 1
      show_current_page()

  $('#form-questions').submit ->
    return validate_question()

  return