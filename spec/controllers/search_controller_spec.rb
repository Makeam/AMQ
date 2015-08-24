require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET #search" do
    let(:request){ get :index, search:{query:'query_string',filter:'Answer'} }
    it "should run Search.search" do
      expect(Search).to receive(:search).with('query_string', 'Answer')
      request
    end
  end
end
