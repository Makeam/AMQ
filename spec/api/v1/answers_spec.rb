require 'rails_helper'

describe 'answers API' do
  let(:user){ create(:user) }
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 2, question: question) }
  let!(:answer) { answers.first }
  let!(:comment) { create(:comment, commentable: answer, user: user) }
  let!(:attachment){ answer.attachments.create(attributes_for(:answer_attachment)) }

  describe 'GET /questions/:question_id/answers' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /answer/:id' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end
    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at user_id rating best).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'Comments' do
        it 'included comments in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at user_id).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'Attachments' do
        it 'included Attachments in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        %w(id).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
          end
        end

        it "contains file path" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/file")
        end
      end
    end
  end

  describe 'POST /questions/:question_id/answers' do
    let(:access_token) { create(:access_token) }
    let(:current_user) { User.find(access_token.resource_owner_id) }
    let(:question) { create(:question) }

    context 'authorized' do
      context 'with valid attributes' do
        let(:request) do
          post "/api/v1/questions/#{question.id}/answers",
              answer: attributes_for(:answer),
              format: :json,
              access_token: access_token.token
        end

        it 'returns status 201' do
          request
          expect(response).to have_http_status :created
        end

        it 'saves answer in database' do
          expect { request }.to change(Answer, :count).by(1)
        end

        it 'assigns created answer to current user' do
          expect { request }.to change(current_user.answers, :count).by(1)
        end
      end

      context 'witn invalid attributes' do
        let(:invalid_params_request) do
          post "/api/v1/questions/#{question.id}/answers",
               answer: attributes_for(:invalid_answer),
              format: :json,
              access_token: access_token.token
        end

        it 'returns status 422' do
          invalid_params_request
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'does not save answer in database' do
          expect { invalid_params_request }.to_not change(Answer, :count)
        end
      end
    end
  end
end