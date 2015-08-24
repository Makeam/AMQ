class QuestionUpdateNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(question)
    question.subscribed_users.find_each do |user|
      NewsMailer.question_update_notification(question, user).deliver_now
    end
  end
end
