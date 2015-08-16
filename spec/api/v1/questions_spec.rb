require 'rails_helper'

describe 'questions API' do
  describe 'GET /questions' do

    let(:method){:get}
    let(:path){'/api/v1/questions'}
    let(:access_token) { create(:access_token) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { do_request(method, path, access_token: access_token.token) }

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end

  end

  describe 'GET /questions/:id' do

    let(:question){ create(:question) }

    let(:method){:get}
    let(:path){ "/api/v1/questions/#{question.id}" }
    let(:access_token){ create(:access_token) }

    it_behaves_like "API Authenticable"

    let(:user){ create(:user) }
    let!(:answer){ create(:answer, question: question) }
    let!(:comment){ create(:comment, commentable: question, user: user) }
    let!(:attachment){ question.attachments.create(attributes_for(:question_attachment)) }

    context 'authorized' do

      before {
        do_request(method, path, access_token: access_token.token)
      }

      it 'returns one of questions' do
        expect(response.body).to have_json_path('question')
      end

      context 'Answers' do
        it 'included answers in question object' do
          expect(response.body).to have_json_size(1).at_path("question/answers")
        end

        %w(id body user_id rating created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
          end
        end
      end

      context 'Comments' do
        it 'included comments in question object' do
          expect(response.body).to have_json_size(1).at_path("question/comments")
        end

        %w(id body created_at user_id).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'Attachments' do
        it 'included Attachments in question object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        %w(id).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
          end
        end

        it "contains file path" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/file")
        end
      end
    end
  end

  describe 'POST /questions' do
    let(:path){"/api/v1/questions"}
    let(:access_token) { create(:access_token) }
    let(:current_user) { User.find(access_token.resource_owner_id) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        do_request(:post, path, question: attributes_for(:question))
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        do_request(:post, path, question: attributes_for(:question), access_token: '1234')
        expect(response.status).to eq 401
      end
    end


    context 'authorized' do
      context 'with valid attributes' do
        let(:request) do
          do_request(:post, path, question: attributes_for(:question), access_token: access_token.token)
        end

        it 'returns status 201' do
          request
          expect(response).to have_http_status :created
        end

        it 'saves question in database' do
          expect { request }.to change(Question, :count).by(1)
        end

        it 'assigns created question to current user' do
          expect { request }.to change(current_user.questions, :count).by(1)
        end
      end

      context 'witn invalid attributes' do
        let(:invalid_params_request) do
          do_request(:post, path, question: attributes_for(:invalid_question), access_token: access_token.token)
        end

        it 'returns status 422' do
          invalid_params_request
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'does not save question in database' do
          expect { invalid_params_request }.to_not change(Question, :count)
        end
      end
    end
  end
end
