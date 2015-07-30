class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable, only: [:voting]

  respond_to :json

  def voting
    if !@votable.blank? and is_not_owner_of?(@votable)
      @vote = Vote.find_or_initialize_by(votable_id: params[:votable_id], votable_type: params[:votable_type], user_id: current_user.id)
      if (@vote.new_record? or different_votes?)
        @vote.update(weight: params[:weight])
        respond_with @vote
      else
        render json: {}, status: :locked
      end
    else
      render json: { status: :forbidden }
    end
  end


  def destroy
    @vote = Vote.find(params[:id])
    @votable = @vote.votable
    @votable_type = @vote.votable_type

    if is_owner_of?(@vote)
      respond_with(@vote.destroy)
    else
      render json:{ status: :forbidden }
    end
  end

  private

  def different_votes?
    params[:weight].to_i != @vote.weight
  end

  def load_votable
    model_klass = params[:votable_type].classify.constantize
    @votable = model_klass.find(params[:votable_id])
  end

end
