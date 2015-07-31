require 'rails_helper'

RSpec.describe Verification, type: :model do
  it { should validate_presence_of :uid }
  it { should validate_presence_of :provider }
  it { should validate_uniqueness_of(:email).scoped_to(:provider)}
end
