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

# what am I doing here
# I'm developing a Rails application, 'm supposed to code a lot in Ruby
# and now JavaScript buggers me in the buggering hell
# file_img : contains the file chosen as image for question
file_img = null

# Displaying the filter criteria when user navigates in list of surveys
# eg: Sorted by: Name / Date created / Date closed
check_filter_criteria = ->
  filter_code = $('#filter-code').text()
  $('#filter_form').find('input[type=radio]').each (index, value) ->
    if $(value).attr('value') == filter_code
      $(value).prop('checked', true)

# Completing a survey, show one only question on each page
show_current_page = ->
  # if there's only ONE choice for the survey
  if total_page == 1
    $('#btn-submit').css('visibility', 'visible')
    $('#btn-prev').css('visibility', 'hidden')
    $('#btn-next').css('visibility', 'hidden')
  # else, more then one choice
  else
    # first question ?
    if current_page == 1
      $('#btn-submit').css('visibility', 'hidden')
      $('#btn-prev').css('visibility','hidden')
    # last question ?
    else if current_page == total_page
      $('#btn-next').css('visibility', 'hidden')
      $('#btn-submit').css('visibility', 'visible')
    # other questions that are not first neither last
    else
      $('#btn-submit').css('visibility', 'hidden')
      $('#btn-prev').css('visibility', 'visible')
      $('#btn-next').css('visibility', 'visible')

  # compute the % of survey's completing and setup the progress bar
  ratio = Math.floor(current_page/total_page * 100)
  $('#progress-questions')
  .css('width', ratio + '%')
  .attr('aria-valuenow', ratio)
  $('#progress-percent').text(ratio + '% Complete' )

  # hide all questions
  $('.question').hide()

  # show the current question
  $('#question' + current_page).fadeIn()
  return

# Validating if the current has been correctly completed
validate_question = ->
  valid = true
  curr_ques = $('#question' + current_page)
  if $(curr_ques).find('input').length != 0
    if $(curr_ques).find('input').is(':checked')
      $(curr_ques).find('.validation-zone').css('visibility', 'hidden')
    else
      $(curr_ques).find('.validation-zone').css('visibility', 'visible')
      valid = false
  return valid

# Creating a question: renumber all choices when a choice has been removed
# Possible optimization: instead of renumbering EVERY choice, determine the ones where this process should begin
# eg: I have in total 50 choices, I remove the 48th, beginning the renumbering process from the 1st makes no sense
# should begin at the 48th choice
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

# convert the number of type_question to a code (string of 2 characters)
type_to_code_question = (type) ->
  switch type
    when 0
      return 'MC'
    when 1
      return 'DD'
    when 2
      return 'OC'
    when 3
      return 'SC'
  return

# file_input_tag & image_tag are just string representing a selector jQuery
load_image_from_file = (file_input_tag, image_tag) ->
  filesSelected = $(file_input_tag)[0].files
  if filesSelected.length > 0
    fileToLoad = filesSelected[0]
    file_img = fileToLoad
    if fileToLoad.type.match('image.*')
      fileReader = new FileReader()
      fileReader.onload = (fileLoadedEvent) ->
        $(image_tag)
        .attr({
          'src': fileLoadedEvent.target.result,
          'alt': 'image',
          'width': '300px',
          'height': '180px'
          })
        .css({
         'margin-top': '15px',
         'display': 'block'
         })
      fileReader.readAsDataURL(fileToLoad)
  return

# after confirming a new question, use this method to show it (HTML) on view
show_question_on_page = (content_question, type_question, content_choices) ->
  # show Question
  p_question = $('<p>').text(content_question).css({ 'font-weight': 'bold', 'margin-bottom': '6px' })
  div_question = $('<div>').css('margin-bottom', '30px').append(p_question)

  # each type of question corresponds to a different showing method
  # not really
  # those types just differ on the type of choices
  # like <input type="checkbox"> / <input type="radio"> / <select><option>1</option>...</select>
  # showing the question, adding image and EDIT / DELETE links are the same
  switch(type_question)
    when 0
      # show Choices
      $(content_choices).each (index, value) ->
        div_choice = $('<div>').addClass('checkbox')
        item_choice = "<label><input type='checkbox'>" + value.content + "</label>"
        $(div_choice).append(item_choice)
        # disable check on checkbox
        $(div_choice).find("input[type='checkbox']").change ->
          this.checked = false
        $(div_question).append(div_choice)

      # show Image
      # show a <img> tag
      img_question = $('<img/>').attr('id', 'img-question-' + current_question)
      load_image_from_file('#question_img', '#img-question-' + current_question)
      # create a hidden input file that is used to upload image to server
      hidden_input_file = $('<input/>')
        .attr({ 
          'type': 'file',
          'name': 'inputfile-' + current_question + '[img]',
          'id'  : 'inputfile-' + current_question + '_img'
        })
        .css('display', 'none')
      $(hidden_input_file)[0].files = file_img
      $(div_question).append(img_question, hidden_input_file)

      # <div> contains 2 <a>: link to EDIT and link to DELETE
      edit_link = $('<a>').text('Edit').css('margin-right', '5px')
      delete_link = $('<a>').text('Delete').css('margin-left', '5px')
      $(div_question).append( $('<div>').append(edit_link, delete_link).css('margin-top', '10px') )

      # appends everything on <div></div> for the whole question
      $('#list-questions').append(div_question)
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
  $('#confirm-question, #cancel-question').addClass('disabled').prop('disabled', true)

# Cancelling a new choice
cancel_choice = (numero_choice) ->
  $('#div-input-choice-' + numero_choice).remove()
  $('#add-choice').css('display', 'block')
  $('#confirm-question, #cancel-question').removeClass('disabled').prop('disabled', false)

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
    $('#confirm-question, #cancel-question').removeClass('disabled').prop('disabled', false)
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
  renumbered_index = 0
  $(arr_choices).each (index, value) ->
    console.log(value)
    if value.no_question == current_question
      value['no_choice'] = ++renumbered_index

# Confirming a question
# type: discriminator for adding / editing
# true: adding
# false: editing
# havent' done the EDITING part yet
confirm_question = (numero_question, type) ->
  if num_choice != 1
    if $('#question-content').val() != ''
      # add new question to array
      new_question = { 
        no_question: numero_question, 
        content: $('#question-content').val(), 
        type_question: type_to_code_question(type_question)
      }
      arr_questions.push(new_question)
      $('#modal-question').modal('hide')
      
      # creating a question (display on page)
      choices_of_question = []
      $(arr_choices).each (index, value) ->
        if value['no_question'] == numero_question
          choices_of_question.push(value)
      show_question_on_page(
        numero_question + '. ' + $('#question-content').val(), type_question, choices_of_question
      )

      # adding a question
      if type
        num_question++
        current_question++
    else
      $('#question-content').attr('placeholder', 'Question cannot have empty content !')
  else
    $('#alert-question').html('<i class="fa fa-exclamation-triangle"></i> A question must have AT LEAST one choice').css('color', 'red')

# Cancelling a question
cancel_question = (numero_question) ->
  $('#modal-question').modal('hide')
  $(arr_choices).each (index, value) ->
    if value['no_question'] = numero_question
      arr_choices.splice(index, 1)

$ ->
  # LIST OF SURVEYS
  # immediately run this method when user load List of Surveys
  check_filter_criteria()

  # COMPLETING A SURVEY
  # get the total number of question and then show the current question
  total_page = $('.question').length
  show_current_page()

  # COMPLETING A SURVEY
  # Previous button: go to previous question when completing a survey
  $('#btn-prev').click (event) ->
    event.preventDefault()
    if current_page > 1 then current_page -=1
    show_current_page()

  # COMPLETING A SURVEY
  # Next button: go to next question when completing a survey
  $('#btn-next').click (event) ->
    event.preventDefault()
    # validate the question here
    valid = validate_question()
    if valid
      if current_page < total_page then current_page += 1
      show_current_page()

  # COMPLETING A SURVEY
  # Submit button is placed on the last page (last question)
  # Fire the valiadation for the last question
  $('#form-questions').submit ->
    return validate_question()

  # CREATING A SURVEY
  # Date-picker to chose Date closed for the survey
  $('#datepicker-closing').datepicker({
    format: 'dd/mm/yyyy'
  })

  # CREATING A SURVEY
  # Reset the modal (to create a single question) each time it is shown
  $('#modal-question').on 'show.bs.modal', ->
    num_choice = 1
    $('#question-content').val('').attr('placeholder', '')
    $('#choices-zone').empty()
    $('#question-img-zone').attr('src', '').css('display', 'none')
    $('#question_img')[0].files = []

  # CREATING A SURVEY
  # Click on Add choice 
  $('#add-choice').click ->
    $('#alert-question').text('')
    add_choice(true)

  # CREATING A SURVEY: confirming the creation of new question
  # Type: discriminator to recognize adding / editing
  # true: adding
  # false: editing
  $('#confirm-question').click ->
    confirm_question(num_question, true)
    return false

  # CREATING A SURVEY: cancelling the creation of new question
  $('#cancel-question').click ->
    cancel_question(num_question)

  # CREATING A SURVEY: click on select box to choose the type of the new question
  # Type of Question: Multiple choices / Dropdown list / One choices only / On the scale
  $('#type_question').find('option').each (index, value) ->
    $(value).click ->
      display_modal_question(index)

  # CREATING A SURVEY: confirming a new survey
  $('#confirm-survey').click ->
    $('#hidden_questions').val(JSON.stringify(arr_questions))
    $('#hidden_choices').val(JSON.stringify(arr_choices))


  # CREATING A SURVEY: resetting a survey
  # erases only the questions, leaves General information intact
  $('#btn-reset-survey').click ->
    #$('#list-questions').empty()
    $('#modal-reset').modal()
    return false

  # CREATING A SURVEY: clicks on button "Upload image" to...yes to upload an image
  $('#btn-question-img').click ->
    $('#question_img').click()

  # CREATING A SURVEY: immediately shows the image on page when a file is chosen
  $('#question_img').on('change', ->
    load_image_from_file('#question_img', '#question-img-zone')
   )

  # CREATING A SURVEY: no I don't want this ugly image, remove it for me
  $('#btn-remove-img').click ->
    $('#question-img-zone').attr('src', '').css('display', 'none')
    $('#question_img')[0].files = null

  return
