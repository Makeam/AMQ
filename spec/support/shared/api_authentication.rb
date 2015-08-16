shared_examples_for "API Authenticable" do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, path)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if there access_token is invalid' do
      do_request(method, path, access_token: '1234' )
      expect(response.status).to eq 401
    end
  end

  context 'authorized' do
    it 'returns status 200' do
      do_request(method, path, access_token: access_token.token )
      expect(response).to be_success
    end
  end
end