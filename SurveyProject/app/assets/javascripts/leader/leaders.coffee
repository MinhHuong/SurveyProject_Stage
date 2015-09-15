# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#dialog-form').submit (event) ->
    event.preventDefault
    return false

  dialog = $('#dialog-form').dialog({
    autoOpen: false,
    height: 300,
    width: 430,
    modal: true,
    buttons:
      'Change': ->
        $.ajax({
          type: 'POST',
          url: '/users/profile/checkpwd/' + $('#user_id').val(),
          data: { oldPwd: $('#oldpwd').val() },
          success: (data) ->
            console.log(data)
            # if the old password is valid
            if(data == true)
              console.log('Haha right old password')
              # if new password == confirm password
              if $('#newpwd').val() == $('#confirmpwd').val() and $('#newpwd').val() != '' and $('#confirmpwd').val() != ''
                $('#user_password').val( $('#newpwd').val() )
                console.log( $('#user_password').val() )
                dialog.dialog('close')
              else
                $('#show-errors').html('New password and confirmed password don\'t look alike (and can\'t be empty) !');
                console.log('u suck so much, cant even retype correctly the new password')
            # if old password not valid
            else
              $('#show-errors').html('Wrong old-password !')
              console.log('Wrong old passwor u piece of shit')
            return
        })
      ,
      Cancel: ->
        dialog.dialog('close')
  })

  $('.ui-dialog-titlebar-close')
  .addClass('ui-button ui-widget ui-state-default ui-corner-all ui-button-icon-only ui-dialog-titlebar-close ui-state-hover')

  $('#change-pwd').on('click', ->
    dialog.dialog('open')
  )

  $('#btn-upload-img').on('click', ->
    $('#upload_img').click()
  )

  $('#upload_img').on('change', ->
    filesSelected = $(this)[0].files
    if filesSelected.length > 0
      fileToLoad = filesSelected[0]
      if fileToLoad.type.match('image.*')
        fileReader = new FileReader()
        fileReader.onload = (fileLoadedEvent) ->
          $('#img-user').attr
            'src': fileLoadedEvent.target.result
          return
        fileReader.readAsDataURL(fileToLoad)
  )

  return