json.question @question, :title, :id
json.question do
    json.user_email @question.user.email
end