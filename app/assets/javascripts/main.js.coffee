update_behavior = ->

  show_edit_form = (th) ->
    $(th).hide()
    answer_id = $(th).data('answerId')
    $('#answer-'+ answer_id + ' .answer-body').hide()
    $('#answer-'+ answer_id + ' .answer-attachments').hide()
    $('#answer-'+ answer_id + ' .edit-answer-form').show()
    $('form.edit_answer').bind 'ajax:success', (e, data, status, xhr) ->
      response = $.parseJSON(xhr.responseText)
      $('textarea#answer_body').val('')
      $('.form-errors').html('')
      $('#answer-' + response.answer.id).html ->
        HandlebarsTemplates['answers/answer'](response)
      update_behavior
    .bind 'ajax:error', (e, xhr, status,error) ->
      errors = $.parseJSON(xhr.responseText)
      $('.form-errors').html('')
      $.each errors, (index, value) ->
        $('.form-errors').append('<p>'+ value + '</p>')
      return
    return

  show_edit_question_form = (th) ->
    $(th).hide()
    $('.question-body-text').hide()
    $('.question-attachments').hide()
    $('.edit-question-form').show()
    $('form.edit_question').bind 'ajax:success', (e, data, status, xhr) ->
      response = $.parseJSON(xhr.responseText)
      $('textarea#question_body').val('')
      $('.question-form-errors').html('')
      $('.question').html ->
        HandlebarsTemplates['questions/question'](response)
      update_behavior
    .bind 'ajax:error', (e, xhr, status,error) ->
      $('.question-form-errors').html('')
      errors = $.parseJSON(xhr.responseText)
      $.each errors, (index, value) ->
        $('.question-form-errors').append('<p>'+ value + '</p>')
      return
    return

  $('a.edit-answer-link').click ->
    show_edit_form(this)
    return false

  $('a.edit-question-link').click ->
    show_edit_question_form(this)
    return false

  $('a.add-comment-link').click ->
    console.log('add-comment-link')
    $(this).hide()
    commentable = {'id': $(this).data('commentableId'), 'type': $(this).data('commentableType')}
    $('.new-comment-form').html ->
      HandlebarsTemplates['comments/form'](commentable)
    $('form#new_comment').bind 'ajax:success',(e, data, status, xhr) ->
      response = $.parseJSON(xhr.responseText)
      if response.commentable_type == 'Answer'
        target = '#answer-' + response.commentable_id
      else
        target = '.question'
      $(target + ' .comments').append ->
        HandlebarsTemplates['comments/comment']( response )
      $(target + ' .new-comment-form').html('')
      $(target + ' a.add-comment-link').show()

    .bind 'ajax:error', (e, xhr, status, error) ->
      console.log('Comment error.')

    return false

  $('.delete-attach').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('p#attach-' + response.id).fadeOut(300)
  .bind 'ajax:error', (e, xhr, status, error) ->
    alert ('error')


  $('.set-best-link').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.answers').html('')
    $.each response.answers, (index, value) ->
      $('.answers').append ->
      HandlebarsTemplates['answers/answer']( value )
    update_behavior
  .bind 'ajax:error', (e, xhr, status, error) ->
    alert ('error')


  $('a.set-vote').bind 'ajax:success', (e, data, status, xhr) ->
    console.log('Set vote success!')
    response = $.parseJSON(xhr.responseText)
    if response.votable_type == 'Answer'
      target = '#answer-' + response.votable_id + ' .rating'
    else
      target = '.question .rating'
    $(target).html ->
      HandlebarsTemplates['answers/rating']( response )
  .bind 'ajax:error', (e, xhr, status, error) ->
      errors = $.parseJSON(xhr.responseText)
      errors.each(index, error) ->
        $('#answer-' + votable_id).prepend(error)


  $('a.cancel-vote').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    if response.votable_type == 'Answer'
      target = '#answer-' + response.votable_id + ' .rating'
    else
      target = '.question .rating'
    $(target).html ->
      HandlebarsTemplates['answers/rating']( response )
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors,(index, error) ->
      $('#answer-' + votable_id).prepend(error)

  $().bind 'ajax'

get_target = (type, id) ->
  if type == 'Answer'
    target = '#answer-' + id
  else
    target = '.question'
  return target

user_is_owner = (userID) ->
  if gon.signed_in
    owner = (gon.current_user_id == userID)
  else
    owner = false
  return owner


ready = ->
  update_behavior



#  $('form#new_answer').bind 'ajax:success', (e, data, status, xhr) ->
#    response = $.parseJSON(xhr.responseText)
#    $('textarea#answer_body').val('')
#    $('.form-errors').html('')
#    $('.answers').append ->
#      HandlebarsTemplates['answers/answer']( response )
#    update_behavior
#  .bind 'ajax:error', (e, xhr, status, error) ->
#    $('.form-errors').html('')
#    errors = $.parseJSON(xhr.responseText)
#    $.each errors, (index, value) ->
#      $('.form-errors').append('<p>'+ value + '</p>')


  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe '/question/' + questionId + '/answers', (data, channel) ->
    response = $.parseJSON(data['response'])
    response.answer_owner = user_is_owner(response.answer.user_id)
    if response.answer_owner
      $('textarea#answer_body').val('')
      $('.form-errors').html('')
    $('.answers').append ->
      HandlebarsTemplates['answers/answer']( response )
    update_behavior


  PrivatePub.subscribe '/questions', (data, channel) ->
    response = $.parseJSON(data['response'])
    $('table.questions').prepend ->
      HandlebarsTemplates['questions/item_question']( response )

#  Здесь могут быть другие обработчики событий и прочий код

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', update_behavior) # "вешаем" функцию на событие page:update
