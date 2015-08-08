class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :created_at, :updated_at, :user_id, :rating

  has_many :comments
  has_many :attachments

end
