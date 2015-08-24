class NewAnswerNotificationJob < ActiveJob::Base
  queue_as :notification

  def perform(question)
    NewsMailer.new_answer_notification(question).deliver_now
  end
end