require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "POST #create" do

    let (:user) { create(:user) }

    context "Question" do
      let!(:commentable){ create(:question) }

      it_behaves_like "Commentable"
    end

    context "Answer" do
      let!(:commentable){ create(:answer) }

      it_behaves_like "Commentable"
    end

  end
end
