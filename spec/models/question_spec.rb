require 'rails_helper'

RSpec.describe Question, type: :model do

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should have_many(:answers).dependent(:destroy) }
  it { should validate_length_of(:title).is_at_least(10).is_at_most(256) }
  it { should validate_length_of(:body).is_at_most(3000) }
  it { should belong_to(:user)}

end
