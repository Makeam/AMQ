class QuestionInCollectionSerializer < QuestionSerializer

  has_many :answers, serializer: AnswerInCollectionSerializer

end
