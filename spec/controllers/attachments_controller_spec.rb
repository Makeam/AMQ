require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe "Remove attached files" do
    let!(:owner){ create(:user ) }
    let!(:user){ create(:user ) }
    let!(:question){ create(:question, user: owner) }
    let!(:answer){ create(:answer, user: owner) }

    before do
      question.attachments.create(attributes_for(:question_attachment))
      answer.attachments.create(attributes_for(:answer_attachment))
    end

    context 'Question\'s owner can delete attached file', js: true do
      it "should delete attachment" do
        sign_in(owner)
        expect{ delete :destroy, id: question.attachments.first.id, format: :js }.to change(question.attachments, :count).by(-1)
      end
      it "Response status: 200" do
        sign_in(owner)
        delete :destroy, id: question.attachments.first.id, format: :js
        expect(response.status).to eq 200
      end
    end

    context 'Not owner of question can\'t delete attached file', js: true do
      it "should NOT delete attachment" do
        sign_in(user)
        expect{ delete :destroy, id: question.attachments.first.id, format: :js }.to change(question.attachments, :count).by(0)
      end
      it "Response status: Forbidden" do
        sign_in(user)
        delete :destroy, id: question.attachments.first.id, format: :js
        expect(response.status).to be_forbidden
      end
    end

    context 'Answer\'s owner can delete attached file', js: true do
      it "should delete attachment" do
        sign_in(owner)
        expect{ delete :destroy, id: answer.attachments.first.id, format: :js }.to change(answer.attachments, :count).by(-1)
      end
      it "Response status: 200" do
        sign_in(owner)
        delete :destroy, id: answer.attachments.first.id, format: :js
        expect(response.status).to be_success
      end
    end

    context 'Not owner of answer can\'t delete attached file', js: true do
      it "should NOT delete attachment" do
        sign_in(user)
        expect{ delete :destroy, id: answer.attachments.first.id, format: :js }.to change(answer.attachments, :count).by(0)
      end
      it "Response status: Forbidden" do
        sign_in(user)
        delete :destroy, id: answer.attachments.first.id, format: :js
        expect(response.status).to be_forbidden
      end
    end
  end
end
