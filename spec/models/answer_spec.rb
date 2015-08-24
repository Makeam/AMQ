require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question}
  it { should belong_to(:user)}

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should validate_length_of(:body).is_at_least(5).is_at_most(3000) }
  it { should validate_numericality_of(:question_id) }

  it_behaves_like "Attachable model"
  it_behaves_like "Commentable model"
  it_behaves_like "Votable model"

  describe "Send notifications" do
    let(:question){create(:question)}
    subject {build(:answer, question: question)}

    it "should send notification to question's owner" do
      expect(NewAnswerNotificationJob).to receive(:perform_later).with(question)
      subject.save!
    end

    it "should send notification to subscribed users" do
      expect(QuestionUpdateNotificationJob).to receive(:perform_later).with(question)
      subject.save!
    end

    it "should not send notification to question's owner after update" do
      subject.save!
      expect(NewAnswerNotificationJob).to_not receive(:perform_later).with(question)
      subject.update(body:"1234567890")
    end

    it "should send notification to subscribed users after update" do
      subject.save!
      expect(QuestionUpdateNotificationJob).to_not receive(:perform_later).with(question)
      subject.update(body:"1234567890")
    end

  end
end
