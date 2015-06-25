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

    if response.vote.votable_type == 'Answer'
      votable = '#answer-' + response.vote.votable_id
    else
      votable = '.question'

    $(votable + ' #cancel-vote').attr('href','/vote/' + response.vote.id)
    $(votable + ' .rating-sum').html(response.rating)

    if response.vote.weight == 1
      $(votable + ' #set-vote-up').hide()
      $(votable + ' #set-vote-down').show()
      $(votable + ' #cancel-vote').show()
    else
      $(votable + ' #set-vote-up').show()
      $(votable + ' #set-vote-down').hide()
      $(votable + ' #cancel-vote').show()

  .bind 'ajax:error', (e, xhr, status, error) ->
      #alert('Error.')
      errors = $.parseJSON(xhr.responseText)
      errors.each(index, error) ->
        $('#answer-' + vote.votable_id).prepend(error)


  $('a.cancel-vote').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)

    if response.type == 'Answer'
      votable = '#answer-' + response.id
    else
      votable = '.question'

    $(votable + ' #set-vote-up').show()
    $(votable + ' #set-vote-down').show()
    $(votable + ' #cancel-vote').hide()
    $(votable + ' .rating-sum').html(response.rating)

  .bind 'ajax:error', (e, data, status, xhr) ->
    #alert('Error canceling.')
    errors = $.parseJSON(xhr.responseText)
    errors.each(index, error) ->
      $('#answer-' + vote.votable_id).prepend(error)

#  Здесь могут быть другие обработчики событий и прочий код

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', ready) # "вешаем" функцию ready на событие page:update
