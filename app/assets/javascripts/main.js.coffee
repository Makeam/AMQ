update_behavior = ->

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

ready = ->

  update_behavior

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

  .bind 'ajax:error', (e, xhr, status, error) ->
    #alert('Error canceling.')
    errors = $.parseJSON(xhr.responseText)
    $.each errors,(index, error) ->
      $('#answer-' + vote.votable_id).prepend(error)

  updateAnswerForm = (id, question_id, body) ->
    formHTML = '<div class="edit-answer-form">
    <form class="edit_answer" id="edit_answer_' + id + '" enctype="multipart/form-data" action="/answers/' + id + '?question_id=' + question_id + '" accept-charset="UTF-8" data-remote="true" method="post">
    <input name="utf8" type="hidden" value="&#x2713;" /><input type="hidden" name="_method" value="patch" />
    <div class="form-group">
    <label for="answer_body">Body</label><textarea class="form-control" rows="2" name="answer[body]" id="answer_body">' + body + '</textarea>
    </div>
    <div class="answer-attachments-fields">
    <div class="add-file-link">
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

  renderAttachments = (attachments) ->
    listHTML = '<div class="answer-attachments">'
    $.each attachments, (index, value) ->
      listHTML += '<p id="attach-' + value.id + '">
      <a href="' + value.url + '">' + value.filename + '</a>&nbsp;<a class="btn btn-xs btn-default" data-remote="true" rel="nofollow" data-method="delete" href="/attachment/' + value.id + '">Delete file</a>
      </p>'
    listHTML += '</div>'
    return listHTML

  $('form#new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    r = $.parseJSON(xhr.responseText)
    f = updateAnswerForm(r.answer.id, r.answer.question_id, r.answer.body)
    a = renderAttachments(r.attachments)
    alert(f)

    $('.form-errors').html('')
    $('.answers').append('<div class="answer" id="answer-' + r.answer.id + '">
    <div class="row">
    <div class="col-md-7"><p class="best-answer"></p></div>
    <div class="col-md-5"><p class="rating pull-right"><div class="rating-sum">' + r.answer.rating + '</div><div class="links"></div></p></div>
    </div>
    <p class="answer-body">' + r.answer.body + '</p>'+ a + f +
    '<a class="btn btn-xs btn-default edit-answer-link" data-answer-id="' + r.answer.id + '" data-remote="true" href="#">Edit</a>
    <a class="btn btn-xs btn-default" data-remote="true" rel="nofollow" data-method="delete" href="/answers/' + r.answer.id + '">Delete my answer</a>
    <p><small>' + r.email + '</small></p>
    </div>
    <hr />')
    update_behavior
  .bind 'ajax:error', (e, xhr, ststus,error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.form-errors').append('<p>'+ value + '</p>')



  #  Здесь могут быть другие обработчики событий и прочий код

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', update_behavior) # "вешаем" функцию ready на событие page:update
