require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe "Remove attached files" do
    let!(:owner){ create(:user ) }
    let!(:user){ create(:user ) }

    context "Question" do
      let!(:attachable){ create(:question, user: owner) }

      it_behaves_like "Attachment destroy"
    end

    context "Answer" do
      let!(:attachable){ create(:answer, user: owner) }

      it_behaves_like "Attachment destroy"
    end
  end
end
