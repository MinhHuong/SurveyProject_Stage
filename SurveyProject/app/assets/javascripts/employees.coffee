# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  dialog = $('#dialog-form').dialog({
    autoOpen: false,
    height: 260,
    width: 430,
    modal: true,
    buttons:
      'Change': ->
        $.ajax({
          type: 'GET',
          url: '/employees/checkpwd/' + $('#user_id').val(),
          data: { oldPwd: $('#oldpwd').val() },
          contentType: 'json',
          success: (data) ->
            # if the old password is valid
            if(data == true)
              console.log('Haha right old password')
              # if new password == confirm password
              if $('#newpwd').val() == $('#confirmpwd').val() and $('#newpwd').val() != '' and $('#confirmpwd').val() != ''
                $('#user_password').val( $('#newpwd').val() )
                dialog.dialog('close')
              else
                console.log('u suck so much, cant even retype correctly the new password')
            # if old password not valid
            else
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
