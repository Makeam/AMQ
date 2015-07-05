json.question @question
json.email @question.user.email
json.attachments @question.attachments do |attachment|
    json.id attachment.id
    json.url attachment.file.url
    json.filename attachment.file.filename
end