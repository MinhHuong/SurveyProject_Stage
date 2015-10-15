# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

current_page = 1
total_page = 0
num_choice = 1
arr_questions = []
arr_choices = []

check_filter_criteria = ->
  filter_code = $('#filter-code').text()
  $('#filter_form').find('input[type=radio]').each (index, value) ->
    if $(value).attr('value') == filter_code
      $(value).prop('checked', true)

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

renumber = (arr_choices) ->
  if $('.choice-form').length == 0
    num_choice = 1
  else
    num_choice--
    $('.choice-form').each (index, value) ->
      $(value).find('.number-choices').text(index+1)
      $(value).find('.content-choices').attr('id', 'content-' + (index+1))
      $(value).find('.edit-choices')
              .attr('id', 'edit-' + (index+1))
              .off('click')
              .click -> edit_choice(index+1)
      $(value).find('.remove-choices')
              .attr('id', 'remove-' + (index+1))
              .off('click')
              .click -> remove_choice(index+1)
      $(this).attr('id', 'choice-' + (index+1))

display_modal_question = (index) ->
  switch(index)
    when 0
      $('#modal-question').modal({ backdrop: 'static' }).find('h3').text('Multiple choices')
    when 1
      console.log('Drop down list')
    when 2
      console.log('One choice only')
    when 3
      console.log('On the scale')
  return

# type (true / false): discriminator for Adding / Editing a choice
# true: adding
# false: editing
add_choice = (type, numero_choice = num_choice) ->
  id_choice = 'input-choice-' + numero_choice
  icon_ok = $('<button>')
  .addClass('btn btn-default glyphicon glyphicon-ok')
  .css({ 'color': 'green', 'margin-left': '20px' })
  .attr('id', 'ok-' + numero_choice)
  .click ->
    confirm_choice(numero_choice)
  label_choice = $('<label></label>').addClass('choice-label col-sm-1').text(numero_choice)
  input_choice = $('<input/>').attr({ 'type': 'text', 'name': id_choice, 'id'  : id_choice, 'size': 40})
  if(!type)
    $(input_choice).val($('#content-' + numero_choice).text())
    $('#choice-' + numero_choice).after($(label_choice), $(input_choice), $(icon_ok)).remove()
  else
    $('#choices-zone').append(label_choice, input_choice, icon_ok)
    num_choice++;
  $('#add-choice').css('display', 'none')

confirm_choice = (numero_choice) ->
  # arr_choices.push($("#input-choice-" + num_choice).val())
  if $("#input-choice-" + numero_choice).val().length == 0
    $("#input-choice-" + numero_choice).attr('placeholder', 'Choice must not be empty !')
  else
    icon_edit = "<button id='edit-" + numero_choice + "' class='edit-choices btn btn-default glyphicon glyphicon-pencil'></button>"
    icon_delete = "<button id='remove-" + numero_choice + "'class='remove-choices btn btn-default glyphicon glyphicon-remove'></button>"
    content_choice = "<p class='choice-form' id='choice-" + numero_choice + "'><span class='number-choices'>" + numero_choice + "</span>.  <span class='content-choices' style='margin-right:12px' id='content-" + numero_choice + "'> " + $("#input-choice-" + numero_choice).val() + "</span> <span class='btn-group'>" + icon_edit + icon_delete + "</span></p>"
    $('#ok-' + numero_choice).after(content_choice)
    $('.choice-label, #input-choice-' + numero_choice + ', #ok-' + numero_choice).remove()
    $('#confirm-choice').css('display', 'none')
    $('#add-choice').css('display', 'block')
    $('#edit-' + numero_choice).click -> 
      edit_choice(numero_choice)
    $('#remove-' + numero_choice).click ->
      remove_choice(numero_choice)

edit_choice = (numero_choice) ->
  console.log(numero_choice)
  add_choice(false, numero_choice)

remove_choice = (numero_choice) ->
  arr_choices.splice(numero_choice-1, 1)
  $('#choice-' + numero_choice).remove()
  renumber($('.number-choices'))

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

  $('#datepicker-closing').datepicker({
    format: 'dd/mm/yyyy'
  })

  $('#modal-question').on 'shown.bs.modal', ->
    num_choice = 1

  $('#add-choice').click ->
    add_choice(true)

  $('#type_question').find('option').each (index, value) ->
    $(value).click ->
      display_modal_question(index)

  return