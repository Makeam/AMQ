$ ->
  show_edit_form = (th) ->
    $(th).hide()
    answer_id = $(th).data('answerId')
    $('#answer-'+ answer_id + ' .answer-body').hide()
    $('#answer-'+ answer_id + ' .edit-answer-form').show()
    return

  show_edit_question_form = (th) ->
    $(th).hide()
    $('.question-body-text').hide()
    $('.edit-question-form').show()
    return

  $('a.edit-answer-link').click ->
    show_edit_form(this)
    return

  $('a.edit-question-link').click ->
    show_edit_question_form(this)
    return

