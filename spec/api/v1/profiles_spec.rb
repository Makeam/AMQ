require 'api/api_config'

describe 'profile API' do
  describe 'GET /profiles/me' do
    let(:me){ create(:user) }
    let(:access_token){ create(:access_token, resource_owner_id: me.id) }
    let(:method){:get}
    let(:path){'/api/v1/profiles/me'}

    it_behaves_like "API Authenticable"

    context 'authorized' do

      before { do_request(method, path, access_token: access_token.token) }

      %w{id email created_at updated_at}.each do |attr|
        it "response contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w{password encrypted_password}.each do |attr|
        it "response does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end

    end
  end

  describe 'GET /profiles' do

    let(:method){:get}
    let(:path){'/api/v1/profiles'}
    let(:access_token){ create(:access_token, resource_owner_id: me.id) }

    it_behaves_like "API Authenticable"

    let(:me){ create(:user) }
    let!(:users) { create_list(:user, 3) }

    context 'authorized' do

      before { do_request(method, path, access_token: access_token.token) }

      it 'response contains a list of users' do
        expect(response.body).to be_json_eql(users.to_json).at_path('profiles')
      end

    end
  end

end