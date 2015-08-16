require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy).order('best DESC') }
  it { should belong_to(:user)}

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_length_of(:title).is_at_least(10).is_at_most(256) }
  it { should validate_length_of(:body).is_at_most(3000) }

  it_behaves_like "Attachable model"
  it_behaves_like "Commentable model"
  it_behaves_like "Votable model"
end
