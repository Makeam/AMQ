json.answer @answer
json.answer_owner is_owner_of?(@answer)
json.question_owner is_owner_of?(@answer.question)
json.email @answer.user.email
json.attachments @answer.attachments do |attachment|
    json.id attachment.id
    json.url attachment.file.url
    json.filename attachment.file.filename
end

json.rating @answer.rating
json.votable_id @answer.id
json.votable_type 'Answer'