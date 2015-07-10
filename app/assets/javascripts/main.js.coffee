updateAnswerForm = (id, question_id, body, attachments) ->
  formHTML = '<div class="edit-answer-form"><div class="form-errors"></div>
  <form class="edit_answer" id="edit_answer_' + id + '" enctype="multipart/form-data" action="/answers/' + id + '?question_id=' + question_id + '" data-type="json" accept-charset="UTF-8" data-remote="true" method="post">
  <input name="utf8" type="hidden" value="&#x2713;" /><input type="hidden" name="_method" value="patch" />
  <div class="form-group">
  <label for="answer_body">Body</label><textarea class="form-control" rows="2" name="answer[body]" id="answer_body">' + body + '</textarea>
  </div>
  <div class="answer-attachments-fields">' + attachments +
  '<div class="add-file-link">
  <a class="add_fields" data-association="attachment" data-associations="attachments" data-association-insertion-template="&lt;div class=&quot;nested-fields&quot;&gt;
  &lt;div class=&quot;form-group&quot;&gt;
  &lt;label for=&quot;answer_attachments_attributes_new_attachments_file&quot;&gt;Attach file&lt;/label&gt;
  &lt;input type=&quot;file&quot; name=&quot;answer[attachments_attributes][new_attachments][file]&quot; id=&quot;answer_attachments_attributes_new_attachments_file&quot; /&gt;
  &lt;/div&gt;
  &lt;input type=&quot;hidden&quot; name=&quot;answer[attachments_attributes][new_attachments][_destroy]&quot; id=&quot;answer_attachments_attributes_new_attachments__destroy&quot; value=&quot;false&quot; /&gt;
  &lt;a class=&quot;remove_fields dynamic&quot; href=&quot;#&quot;&gt;remove file&lt;/a&gt;
  &lt;/div&gt;" href="#">Add file</a>
  </div>
  </div>
  <div class="form-group">
  <input type="submit" name="commit" value="Save" class="btn btn-sm btn-primary" />
  </div>
  </form>
  </div>'
  return formHTML

updateQuestionForm = (id, title, body, attachments) ->

  formHTML = '<div class="question-form-errors"></div>
  <div class="edit-question-form">
  <form class="edit_question" id="edit_question" enctype="multipart/form-data" action="/questions/' + id + '" accept-charset="UTF-8" data-remote="true" method="post">
  <input name="utf8" type="hidden" value="&#x2713;" /><input type="hidden" name="_method" value="patch" />
  <div class="form-group">
  <label for="question_title">Title</label><input class="form-control" type="text" value="' + title + '" name="question[title]" id="question_title" />
  </div>
  <div class="form-group">
  <label for="question_body">Body</label><textarea class="form-control" rows="5" name="question[body]" id="question_body">' + body + '</textarea>
  </div>
  <div class="question-attachments-fields">' + attachments +
  '<input type="hidden" value="88" name="question[attachments_attributes][0][id]" id="question_attachments_attributes_0_id" />
  <div class="add-file-link">
  <a class="add_fields" data-association="attachment" data-associations="attachments" data-association-insertion-template="&lt;div class=&quot;nested-fields&quot;&gt;
  &lt;div class=&quot;form-group&quot;&gt;
  &lt;label for=&quot;question_attachments_attributes_new_attachments_file&quot;&gt;Attach file&lt;/label&gt;&lt;input type=&quot;file&quot; name=&quot;question[attachments_attributes][new_attachments][file]&quot; id=&quot;question_attachments_attributes_new_attachments_file&quot; /&gt;
  &lt;/div&gt;
  &lt;input type=&quot;hidden&quot; name=&quot;question[attachments_attributes][new_attachments][_destroy]&quot; id=&quot;question_attachments_attributes_new_attachments__destroy&quot; value=&quot;false&quot; /&gt;&lt;a class=&quot;remove_fields dynamic&quot; href=&quot;#&quot;&gt;remove file&lt;/a&gt;
  &lt;/div&gt;" href="#">Add file</a>
  </div>
  </div>
  <div class="form-group"><input type="submit" name="commit" value="Save" class="btn btn-primary" /></div>
  </form>
  </div>'
  return formHTML

renderAttachments = (attachments) ->
  listHTML = ''
  $.each attachments, (index, value) ->
    listHTML += '<p id="attach-' + value.id + '">
    <a href="' + value.url + '">' + value.filename + '</a>&nbsp;<a class="btn btn-xs btn-default" data-remote="true" rel="nofollow" data-method="delete" href="/attachment/' + value.id + '">Delete file</a>
    </p>'
  return listHTML

renderSetBest = (a, canSetBest) ->
  if a.best
    setBestHTML = '<p class="best-answer"><span class="best-answer-label label-success">Best answer</span></p>'
  else
    if canSetBest
      setBestHTML = '<p class="best-answer"><a class="set-best-link" data-remote="true" rel="nofollow" data-method="patch" href="/answers/' + a.id + '/set_best">Set best</a></p>'
    else
      setBestHTML = '<p class="best-answer"></p>'
  return setBestHTML

renderVoteLinks = (a, canRate, vote) ->

  linksHTML = '<div class="links"></div>'
  if canRate
    visible_up = ''
    visible_down = ''
    visible_cancel = ''
    if vote
      vote_id = vote.id
      if vote.weight == 1
        visible_up = 'display: none;'
      else
        visible_down = 'display: none;'
    else
      visible_cancel = 'display: none;'
      vote_id = ''
    linksHTML = '<div class="links">
    <a id="set-vote-up" class="set-vote butt btn btn-xs btn-default" style="' + visible_up + '" data-remote="true" rel="nofollow" data-method="patch" href="/votes/set_vote?votable_id=' + a.id + '&amp;votable_type=Answer&amp;weight=1"
    >up</a><a id="set-vote-down" class="set-vote butt btn btn-xs btn-default" style="' + visible_down + '" data-remote="true" rel="nofollow" data-method="patch" href="/votes/set_vote?votable_id=' + a.id + '&amp;votable_type=Answer&amp;weight=-1"
    >down</a><a id="cancel-vote" class="cancel-vote butt btn btn-xs btn-default" style="' + visible_cancel + '" data-remote="true" rel="nofollow" data-method="delete" href="/vote/' + vote_id + '">cancel my vote</a>
    </div>'
  return linksHTML

renderAnswer = (r) ->
  a = renderAttachments(r.attachments)
  f = updateAnswerForm(r.answer.id, r.answer.question_id, r.answer.body, a)
  setBest = renderSetBest(r.answer, r.canSetBest)
  voteLinks = renderVoteLinks(r.answer, r.canRate, r.userVote)

  answer_code = '<div class="answer" id="answer-' + r.answer.id + '">
  <div class="row">
  <div class="col-md-7">' + setBest + '</div>
  <div class="col-md-5"><p class="rating pull-right"><div class="rating-sum label-default">' + r.answer.rating + '</div>' + voteLinks + '</p></div>
  </div>
  <p class="answer-body">' + r.answer.body + '</p> <div class="answer-attachments">' + a + '</div>' + f +
  '<a class="btn btn-xs btn-default edit-answer-link" data-answer-id="' + r.answer.id + '" data-remote="true" href="#">Edit</a>
  <a class="btn btn-xs btn-default" data-remote="true" rel="nofollow" data-method="delete" href="/answers/' + r.answer.id + '">Delete my answer</a>
  <p><small>' + r.email + '</small></p>
  </div>
  <hr />'
  return answer_code

renderQuestion = (r) ->
  a = renderAttachments (r.attachments)
  f = updateQuestionForm(r.question.id, r.question.title, r.question.body, a)

  question_code = '<div class="question"><h1>' + r.question.title + '</h1>
  <p class="rating">
  <div class="rating-sum label-default">' + r.question.rating + '</div>
  <div class="links"></div>
  </p>
  <div class="clearfix"></div>
  <p class="question-body-text">' + r.question.body + '</p>
  <div class="question-attachments">' + a + '</div>' + f + '<p>
  <a class="btn btn-xs btn-default edit-question-link" data-remote="true" href="">Edit</a>
  <a class="btn btn-xs btn-default" rel="nofollow" data-method="delete" href="/questions/' + r.question.id + '">Delete my question</a>
  </p>
  <p><small>' + r.email + '</small></p>
  <hr />
  </div>'
  return question_code

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
      $('#answer-' + response.answer.id).html( renderAnswer(response) )
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
      $('.question').html( renderQuestion(response) )
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
    return

  $('.set-best-link').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    answersHTML = ''
    $.each response.answers, (index, value) ->
      answersHTML += renderAnswer(value)
    $('.answers').html(answersHTML)
    update_behavior
    set_vote_link_behavior
  .bind 'ajax:error', (e, xhr, status, error) ->
    alert ('error')



set_vote_link_behavior = ->

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

  .bind 'ajax:error', (e, xhr, status, error) ->
    #alert('Error canceling.')
    errors = $.parseJSON(xhr.responseText)
    $.each errors,(index, error) ->
      $('#answer-' + vote.votable_id).prepend(error)


ready = ->

  update_behavior
  set_vote_link_behavior

  #JSON



  $('form#new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('textarea#answer_body').val('')
    $('.form-errors').html('')
    $('.answers').append( renderAnswer(response) )
    update_behavior
  .bind 'ajax:error', (e, xhr, status, error) ->
    $('.form-errors').html('')
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.form-errors').append('<p>'+ value + '</p>')




#  Здесь могут быть другие обработчики событий и прочий код

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', update_behavior) # "вешаем" функцию на событие page:update
