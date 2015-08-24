require "rails_helper"

RSpec.describe NewsMailer, type: :mailer do
  let(:user){create(:user)}
  let!(:question){create(:question, user: user)}

  describe "#daily_digest" do
    let!(:email){ NewsMailer.daily_digest(user).deliver_now }

    it "should send mail to user" do
      expect(email.to.first).to eq user.email
    end

    it "should contain question title" do
      expect(email.body).to have_content question.title
    end
  end

  describe "#new_answer_notification" do
    let!(:email){ NewsMailer.new_answer_notification(question).deliver_now }
    it "should send mail to user" do
      expect(email.to.first).to eq user.email
    end

    it "should contain title - New answer" do
      expect(email.subject).to have_content "New answer"
    end
    end

  describe "#question_update_notification" do
    let!(:email){ NewsMailer.question_update_notification(question, user).deliver_now }
    it "should send mail to user" do
      expect(email.to.first).to eq user.email
    end

    it "should contain title - New answer" do
      expect(email.subject).to have_content "New answer"
    end

    it "should contain text - subscribed" do
      expect(email.body).to have_content "You are subscribed"
    end
  end
end
