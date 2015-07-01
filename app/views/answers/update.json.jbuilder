json.answer @answer
json.email @answer.user.email
json.attachments @answer.attachments do |attachment|
    json.id attachment.id
    json.url attachment.file.url
    json.filename attachment.file.filename
end