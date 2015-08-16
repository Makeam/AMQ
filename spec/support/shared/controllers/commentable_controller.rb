shared_examples_for "Commentable" do

  let(:comment){ build(:comment, commentable: commentable) }
  let(:invalid_comment){ build(:invalid_comment, commentable: commentable) }
  let(:request){ post :create, comment: comment.attributes, format: :json }
  let(:invalid_params_request){ post :create, comment: invalid_comment.attributes, format: :json }
  let(:publish_path){ "/question/#{get_question_id}/comments" }

  before{ sign_in(user) }

  context 'valid attributes' do
    it 'Save comment into database' do
      expect { request }.to change(Comment, :count).by(1)
    end

    it 'Create new comment associated with commentable' do
      request
      comment = assigns(:comment)
      expect(comment.user_id).to eq user.id
      expect(comment.commentable).to eq commentable
    end
  end
  context 'invalid attributes' do
    it 'Don\'t create new comment' do
      expect { invalid_params_request }.to_not change(Comment, :count)
    end
  end

  it_behaves_like "Publishable"

  def get_question_id
    commentable.try(:question) ? commentable.question.id : commentable.id
  end
end