require 'rails_helper'

RSpec.describe QuestionUpdateNotificationJob, type: :job do

  let(:user_1){create(:user)}
  let(:user_2){create(:user)}
  let(:user_3){create(:user)}
  let(:question){create(:question)}
  let(:subscribe_1){create(:subscribe, qusetion: question, user: user_1)}
  let(:subscribe_2){create(:subscribe, qusetion: question, user: user_2)}
  let(:subscribe_3){create(:subscribe, qusetion: question, user: user_3)}

  it 'sends notification subscribed users' do
    question.subscribed_users.each do |user|
      expect(NewsMailer).to receive(:question_update_notification).with(user)
    end
    QuestionUpdateNotificationJob.perform_now(question)
  end
end
