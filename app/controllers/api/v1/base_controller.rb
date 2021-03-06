class Api::V1::BaseController < ApplicationController

  before_action :doorkeeper_authorize!
  respond_to :json

  protect_from_forgery with: :null_session

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # This alias method is for CanCan
  alias_method :current_user, :current_resource_owner
end