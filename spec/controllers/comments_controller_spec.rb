require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "POST #create" do

    let (:user) { create(:user) }
    let (:question) { create(:question, user: user) }
    let (:answer) { create(:answer, question: question, user: user) }
    let (:comment) {create(:comment, user: user, commentable: answer)}

    it 'Create new comment' do
      sign_in(user)
      expect { post :create, comment:{commentable_id: answer.id, commentable_type: 'Answer', body:'newComment'}, format: :json }.to change(Comment, :count).by(1)
    end

    it 'Create new comment associated with answer' do
      sign_in(user)
      post :create, comment:{commentable_id: answer.id, commentable_type: 'Answer', body:'newComment'}
      comment = assigns(:comment)
      expect(comment.user_id).to eq user.id
      expect(comment.commentable).to eq answer
    end

  end

end
