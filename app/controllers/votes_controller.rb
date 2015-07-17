class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable, only: [:set_vote]

  def set_vote
    if !@votable.blank? and is_not_owner_of?(@votable)
      @vote = Vote.find_or_initialize_by(votable_id: params[:votable_id], votable_type: params[:votable_type], user_id: current_user.id)

      if different_votes? and @vote.update(weight: params[:weight])

      else
        render json: @vote.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: { status: :forbidden }
    end
  end


  def destroy
    @vote = Vote.find(params[:id])
    votable = @vote.votable
    votable_type = @vote.votable_type

    if is_not_owner_of?(votable)
      if @vote.destroy
        render json: {votable_id: votable.id, votable_type: votable_type, rating: votable.rating, canRate: true }
      else
        render json: @vote.errors.full_messages, status: :unprocessable_entity
      end
    else
      render json: { status: :forbidden }
    end
  end

  private

  def different_votes?
    params[:weight].to_i != @vote.weight
  end

  def set_votable
    model_klass = params[:votable_type].classify.constantize
    @votable = model_klass.find(params[:votable_id])
  end

end
