class VotesController < ApplicationController
  before_action :authenticate_user!

  def set_vote
    @vote = Vote.find_or_create_by(votable_id: params[:votable_id], votable_type: params[:votable_type], user_id: current_user.id)
    respond_to do |format|
      if @vote.update(weight: params[:weight])
        format.json { render json: @vote}
      else
        format.json { render json: @vote.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @vote = Vote.find(params[:id])
    votable_id = @vote.votable_id
    votable_type = @vote.votable_type
    respond_to do |format|
      if @vote.destroy
        format.json { render json: {id: votable_id, type: votable_type} }
      else
        format.json { render json: @vote.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

end
