json.answer @answer
json.canRate is_not_owner_of?(@answer)
json.canSetBest is_owner_of?(@answer.question)
json.email @answer.user.email
json.attachments @answer.attachments do |attachment|
    json.id attachment.id
    json.url attachment.file.url
    json.filename attachment.file.filename
end