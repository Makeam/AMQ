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
      $.each response.comments, (index, value) ->
#        alert(value)
        $('#answer-' + response.answer.id + ' .comments').append ->
          HandlebarsTemplates['comments/comment'](value)
        return
      update_behavior()
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
    update_behavior()
  .bind 'ajax:error', (e, xhr, status, error) ->
    alert ('error')


  $('a.set-vote').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    target = get_target(response.votable_type, response.votable_id) + ' .rating'
    $(target).html ->
      HandlebarsTemplates['answers/rating']( response )
  .bind 'ajax:error', (e, xhr, status, error) ->
      errors = $.parseJSON(xhr.responseText)
      errors.each(index, error) ->
        $('#answer-' + votable_id).prepend(error)


  $('a.cancel-vote').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    target = get_target(response.votable_type, response.votable_id) + ' .rating'
    $(target).html ->
      HandlebarsTemplates['answers/rating']( response )
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors,(index, error) ->
      $('#answer-' + votable_id).prepend(error)


  $('a.add-comment-link').click ->
    $(this).hide()
    commentable = {'id': $(this).data('commentableId'), 'type': $(this).data('commentableType')}
    target = get_target(commentable.type, commentable.id)
    $(target + ' .new-comment-form').html ->
      HandlebarsTemplates['comments/form'](commentable)
    $('form#new_comment').bind 'ajax:success',(e, data, status, xhr) ->
      response = $.parseJSON(xhr.responseText)
      target = get_target(response.commentable_type, response.commentable_id)
      $(target + ' .new-comment-form').html('')
      $(target + ' a.add-comment-link').show()
      addComment(target, response)

    .bind 'ajax:error', (e, xhr, status, error) ->
      console.log('Comment error.')
    return false

#####  END of update_behavior

addComment = (target, comment) ->
  if !$(target + ' .comments #comment-' + comment.id).length
    $(target + ' .comments').append ->
      HandlebarsTemplates['comments/comment']( comment )
  return


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
    update_behavior()

  PrivatePub.subscribe '/question/' + questionId + '/comments', (data, channel) ->
    response = $.parseJSON(data['response'])
    target = get_target(response.commentable_type, response.commentable_id)
    addComment(target, response)

  PrivatePub.subscribe '/questions', (data, channel) ->
    response = $.parseJSON(data['response'])
    $('table.questions').prepend ->
      HandlebarsTemplates['questions/item_question']( response )

##### END of ready

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', update_behavior) # "вешаем" функцию на событие page:update
