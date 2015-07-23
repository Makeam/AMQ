json.extract! @comment, :id, :commentable_id, :commentable_type, :body
json.user_email @comment.user.email
