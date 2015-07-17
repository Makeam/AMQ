json.question @question
json.email @question.user.email
json.attachments @question.attachments do |attachment|
    json.id attachment.id
    json.url attachment.file.url
    json.filename attachment.file.filename
end

json.rating @question.rating
json.votable_id @question.id
json.votable_type 'Question'
json.canRate false