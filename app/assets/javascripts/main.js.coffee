ready = ->
  # Это наш обработчик, перенесенный сюда из document.ready ($ ->)

  show_edit_form = (th) ->
    $(th).hide()
    answer_id = $(th).data('answerId')
    $('#answer-'+ answer_id + ' .answer-body').hide()
    $('#answer-'+ answer_id + ' .answer-attachments').hide()
    $('#answer-'+ answer_id + ' .edit-answer-form').show()
    return

  show_edit_question_form = (th) ->
    $(th).hide()
    $('.question-body-text').hide()
    $('.question-attachments').hide()
    $('.edit-question-form').show()
    return

  $('a.edit-answer-link').click ->
    show_edit_form(this)
    return

  $('a.edit-question-link').click ->
    show_edit_question_form(this)
    return

  #JSON

  $('a.set-vote').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    $('#answer-' + vote.answer_id + ' #cancel-vote').attr('href','/vote/' + vote.id)
    if vote.weight == 1
      $('#answer-' + vote.answer_id + ' #set-vote-up').hide()
      $('#answer-' + vote.answer_id + ' #set-vote-down').show()
      $('#answer-' + vote.answer_id + ' #cancel-vote').show()
    else
      $('#answer-' + vote.answer_id + ' #set-vote-up').show()
      $('#answer-' + vote.answer_id + ' #set-vote-down').hide()
      $('#answer-' + vote.answer_id + ' #cancel-vote').show()

  .bind 'ajax:error', (e, xhr, status, error) ->
      alert('Error.')
      #errors = $.parseJSON(xhr.responseText)


  $('a.cancel-vote').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    $('#answer-' + vote.id + ' #set-vote-up').show()
    $('#answer-' + vote.id + ' #set-vote-down').show()
    $('#answer-' + vote.id + ' #cancel-vote').hide()

  .bind 'ajax:error', (e, data, status, xhr) ->
    alert('Error canceling.')

#  Здесь могут быть другие обработчики событий и прочий код

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', ready) # "вешаем" функцию ready на событие page:update
