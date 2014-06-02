# page:load is for turbolinks
$(document).bind 'page:load', ->
  init()

jQuery ->
  init()

currentXHR = null

init = ->
  # instant search

  $('#search').keyup (e) ->
    if $(this).val().length > 0
      $('.main-content').hide()
      $('.ajax-content').show()
      # disable previous ajax request
      if currentXHR != null
        currentXHR.abort()
      $(this).parents('form').submit()
    else
      $('.main-content').show()
      $('.ajax-content').html('').hide()

  # save ajax request so it can be disabled later
  $('#search').parents('form').bind 'ajax:beforeSend', (e, jqXHR) ->
    currentXHR = jqXHR


  # I've found following code for 'tab in textarea' somewhere on stack overflow and then 
  # rewritten it to coffee script. Unfortunately I do not have question URL anymore.

  # allow tab key in textarea
  $("textarea").keydown (e) ->
    # 9 is for tab key
    if e.keyCode == 9
      # get caret position/selection
      start = @.selectionStart
      end = @.selectionEnd

      $this = $(this)
      value = $this.val()

      # set textarea value to: text before caret + tab + text after caret
      $this.val("#{value.substring(0, start)}  #{value.substring(end)}")

      # put caret at right position again (add one for the tab)
      @.selectionStart = @.selectionEnd = start + 2

      # prevent the focus lose
      e.preventDefault()
