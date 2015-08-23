class QuestionUpdateNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(question)
    question.subscribed_users.find_each do |user|
      sleep(2)
      NewsMailer.question_update_notification(question, user).deliver_later
    end
  end
end
