require 'rails_helper'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  it { should validate_presence_of :email}
  it { should validate_presence_of :password}
  it { should validate_uniqueness_of :email}

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

end
