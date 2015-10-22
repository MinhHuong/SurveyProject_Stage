# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# current page (doing a survey)
current_page = 1

# total page (sum of all questions of a survey)
total_page = 0

# numero of current choice (on a modal)
num_choice = 1

# numero of total question
num_question = 1

# numero of current questions
current_question = 1

# array of questions: { no_question: ..., content: ... }
# content: content of question
arr_questions = []

# array of choices: { no_question: ..., no_choice: ..., content: ... }
# content: content of choices
arr_choices = []

# Distinguish the 3 types of question
# 0 : Multiple choices
# 1 : Drop down list
# 2 : One choice only
# 3 : Scale
type_question = 0

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

renumber = (numero_question) ->
  if $('.choice-form').length == 0
    num_choice = 1
  else
    num_choice--
    $('.choice-form').each (index, value) ->
      numero = index + 1
      $(value).find('.number-choices').text(numero)
      $(value).find('.content-choices').attr('id', 'content-' + (numero))
      $(value).find('.edit-choices')
              .attr('id', 'edit-' + (numero))
              .off('click')
              .click -> edit_choice(numero)
      $(value).find('.remove-choices')
              .attr('id', 'remove-' + (numero))
              .off('click')
              .click -> remove_choice(numero, numero_question)
      $(this).attr('id', 'choice-' + (numero))

show_question_on_page = (content_question, type_question, content_choices) ->
  div_question = $('<div>').css('margin-bottom', '30px')
  p_question = $('<p>').text(content_question).css({ 'font-weight': 'bold', 'margin-bottom': '6px' })
  switch(type_question)
    when 0
      $(content_choices).each (index, value) ->
        div_choice = $('<div>').addClass('checkbox')
        item_choice = "<label><input type='checkbox'>" + value.content + "</label>"
        $(div_choice).append(item_choice)
        $(div_question).append(div_choice)
      $('#list-questions').append(p_question, div_question)
    when 1
      console.log('Drop down list')
    when 2
      console.log('One choice only')
    when 3
      console.log('On the scale')
  return

display_modal_question = (index) ->
  # index = 0, 1, 2, 3...corresponds to type_question (also) = 0, 1, 2, 3
  type_question = index
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
  # Icon: confirm choice
  icon_ok = $('<button>')
   .addClass('btn btn-default glyphicon glyphicon-ok')
   .css({ 'color': 'green', 'margin-left': '10px' })
   .attr('id', 'ok-' + numero_choice)
   .click ->
     confirm_choice(numero_choice, type)
  
  # Icon: cancel choice
  icon_cancel = $('<button>')
   .addClass('btn btn-default glyphicon glyphicon-remove')
   .css({ 'color': 'orange', 'margin-left': '10px' })
   .attr('id', 'cancel-' + numero_choice)
   .click ->
     cancel_choice(numero_choice)
  
  # Label (numero of choice)
  label_choice = $('<label>').addClass('choice-label col-sm-1').text(numero_choice)
  
  # Input: type content of choice
  input_choice = $('<input/>')
   .attr({ 'type': 'text', 'name': 'input-choice-' + numero_choice, 'id': 'input-choice-' + numero_choice })
   .addClass('form-control col-sm-2')
  # <div class='form-group'><input..></div> --> apply better CSS on input's width
  div_input = $('<div>').addClass('col-sm-8').append(input_choice)
  
  # All div: label, input, icon OK, icon CANCEL
  div_input_choice = $('<div><')
   .append(label_choice, div_input, icon_ok, icon_cancel)
   .attr('id', 'div-input-choice-' + numero_choice)
   .addClass('form-group')
  
  # Editing
  if(!type)
    $(input_choice).val($('#content-' + numero_choice).text())
    $('#choice-' + numero_choice).after(div_input_choice).remove()
  # Adding
  else
    $('#choices-zone').append(div_input_choice)
    $(input_choice).focus()
  
  # Hide button "Add choice"
  $('#add-choice').css('display', 'none')

# Cancelling a new choice
cancel_choice = (numero_choice) ->
  $('#div-input-choice-' + numero_choice).remove()
  $('#add-choice').css('display', 'block')

# Confirming a choice
# type: discrimator to recognize this action is for adding / editing
confirm_choice = (numero_choice, type) ->
  # arr_choices.push($("#input-choice-" + num_choice).val())

  # Validate if choice is not empty
  if $("#input-choice-" + numero_choice).val().length == 0
    $("#input-choice-" + numero_choice).attr('placeholder', 'Choice must not be empty !')
  else
    # remove the alert (if existing) in the modal's footer
    $('#alert-question').text('')

    # adding choice
    if type
      new_choice = { no_question: num_question, no_choice: numero_choice, content: $("#input-choice-" + numero_choice).val() }
      arr_choices.push(new_choice)
      console.log(arr_choices)
      num_choice++
    # editing choice
    else
      arr_choices[numero_choice-1]['content'] = $("#input-choice-" + numero_choice).val()
      console.log(arr_choices)

    # Icon: editing a choice
    icon_edit = "<button id='edit-" + numero_choice + "' class='edit-choices btn btn-default glyphicon glyphicon-pencil' style='color: #0080FF'></button>"

    # Icon: removing a choice
    icon_delete = "<button id='remove-" + numero_choice + "'class='remove-choices btn btn-default glyphicon glyphicon-fire' style='color: red'></button>"

    # Complete content of a choice, eg: 1. Green
    # <p>
    #   <span class='number-choices'> 1 </span>
    #   <span class='content-choices' style='..' id='content-1'> Green </span>
    #   <span class='btn-group'> icon edit $ delete </span>
    # </p>
    content_choice = "<p class='choice-form' id='choice-" + numero_choice + "'><span class='number-choices'>" + numero_choice + "</span>.  <span class='content-choices' style='margin-right:12px' id='content-" + numero_choice + "'> " + $("#input-choice-" + numero_choice).val() + "</span> <span class='btn-group'>" + icon_edit + icon_delete + "</span></p>"
    $('#div-input-choice-' + numero_choice).after(content_choice).remove()
    $('#add-choice').css('display', 'block')
    $('#edit-' + numero_choice).click -> 
      edit_choice(numero_choice)
    $('#remove-' + numero_choice).click ->
      remove_choice(numero_choice)

# Editing a choice (reuse add_choice, take type (true/false) as discriminator)
edit_choice = (numero_choice) ->
  add_choice(false, numero_choice)

# Remove a choice & Renumber choices
remove_choice = (numero_choice) ->
  index_remove = 0
  console.log(current_question + ' ' + numero_choice)
  for value in arr_choices
    if value.no_question == current_question and value.no_choice == numero_choice
      break
    index_remove++

  arr_choices.splice(index_remove, 1)
  $('#choice-' + numero_choice).remove()
  renumber($('.number-choices'))
  
  # renumber arr_choices (for involved question)
  console.log(current_question)
  renumbered_index = 0
  $(arr_choices).each (index, value) ->
    console.log(value)
    if value.no_question == current_question
      value['no_choice'] = ++renumbered_index
  console.log(arr_choices)

# Confirming a question
confirm_question = (numero_question, type) ->
  if num_choice != 1
    if $('#question-content').val() != ''
      # adding a question
      if type
        num_question++
        current_question++
      # add new question to array
      new_question = { no_question: numero_question, content: $('#question-content').val() }
      arr_questions.push(new_question)
      # console.log(arr_questions)
      $('#modal-question').modal('hide')
      
      # creating a question (display on page)
      choices_of_question = []
      $(arr_choices).each (index, value) ->
        if value['no_question'] == numero_question
          choices_of_question.push(value)
      console.log(choices_of_question)
      show_question_on_page(
        numero_question + '. ' + $('#question-content').val(), type_question, choices_of_question
      )
    else
      $('#question-content').attr('placeholder', 'Question cannot have empty content !')
  else
    $('#alert-question').html('<i class="fa fa-exclamation-triangle"></i> A question must have AT LEAST one choice').css('color', 'red')

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

  $('#modal-question').on 'show.bs.modal', ->
    num_choice = 1
    $('#question-content').val('')
    $('#choices-zone').empty()

  $('#add-choice').click ->
    $('#alert-question').text('')
    add_choice(true)

  # Type: discriminator to recognize adding / editing
  # true: adding
  # false: editing
  $('#confirm-question').click (type) ->
    confirm_question(num_question, true)

  $('#type_question').find('option').each (index, value) ->
    $(value).click ->
      display_modal_question(index)

  return