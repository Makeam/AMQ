require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question}
  it { should belong_to(:user)}
  it { should have_many(:attachments).dependent(:destroy)}
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:votes).dependent(:destroy)}

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should validate_length_of(:body).is_at_least(5).is_at_most(3000) }
  it { should validate_numericality_of(:question_id) }
end
