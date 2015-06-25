require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }

  it { should validate_presence_of :votable_id }
  it { should validate_presence_of :votable_type }
  it { should validate_presence_of :weight }
  it { should validate_inclusion_of(:weight).in_array([-1,0,1]) }
end
