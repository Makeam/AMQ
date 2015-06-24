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
    response = $.parseJSON(xhr.responseText)

    $('#answer-' + response.vote.votable_id + ' #cancel-vote').attr('href','/vote/' + response.vote.id)
    $('#answer-' + response.vote.votable_id + ' .rating-sum').html(response.rating)

    if response.vote.weight == 1
      $('#answer-' + response.vote.votable_id + ' #set-vote-up').hide()
      $('#answer-' + response.vote.votable_id + ' #set-vote-down').show()
      $('#answer-' + response.vote.votable_id + ' #cancel-vote').show()
    else
      $('#answer-' + response.vote.votable_id + ' #set-vote-up').show()
      $('#answer-' + response.vote.votable_id + ' #set-vote-down').hide()
      $('#answer-' + response.vote.votable_id + ' #cancel-vote').show()

  .bind 'ajax:error', (e, xhr, status, error) ->
      #alert('Error.')
      errors = $.parseJSON(xhr.responseText)
      errors.each(index, error) ->
        $('#answer-' + vote.votable_id).prepend(error)


  $('a.cancel-vote').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('#answer-' + response.id + ' #set-vote-up').show()
    $('#answer-' + response.id + ' #set-vote-down').show()
    $('#answer-' + response.id + ' #cancel-vote').hide()
    $('#answer-' + response.id + ' .rating-sum').html(response.rating)

  .bind 'ajax:error', (e, data, status, xhr) ->
    #alert('Error canceling.')
    errors = $.parseJSON(xhr.responseText)
    errors.each(index, error) ->
      $('#answer-' + vote.votable_id).prepend(error)

#  Здесь могут быть другие обработчики событий и прочий код

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', ready) # "вешаем" функцию ready на событие page:update
