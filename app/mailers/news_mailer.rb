class NewsMailer < ApplicationMailer

  def daily_digest(user)
    @questions = Question.where("created_at > ?", Time.now - 1.day)
    mail(to: user.email, subject: "Daily digest.")
  end

  def new_answer_notification(question)
    @question = question
    mail(to: question.user.email, subject: "New answer.")
  end

  def question_update_notification(question, user)
    @question = question
    mail(to: user.email, subject: "New answer.")
  end

end
