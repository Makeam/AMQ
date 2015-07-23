json.answers @answer.question.answers do |answer|
    json.answer answer
    json.answer_owner is_owner_of?(answer)
    json.question_owner is_owner_of?(answer.question)
    if answer.user_vote(current_user) != nil
        json.userVote answer.user_vote(current_user)
    else
        json.userVote false
    end
    json.email answer.user.email
    json.attachments answer.attachments do |attachment|
        json.id attachment.id
        json.url attachment.file.url
        json.filename attachment.file.filename
    end
end