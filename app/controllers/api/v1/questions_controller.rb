class Api::V1::QuestionsController < ApplicationController
  before_action :doorkeeper_authorize!
  respond_to :json

  def index
    @questions = Question.all
    respond_with @questions
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end