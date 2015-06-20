class VotesController < ApplicationController
  before_action :authenticate_user!

  def set_vote
    @vote = Vote.find_or_create_by(answer_id: params[:answer_id], user_id: current_user.id)
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
    answer_id = @vote.answer_id
    respond_to do |format|
      if @vote.destroy
        format.json { render json: {id: answer_id} }
      else
        format.json { render json: @vote.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

end
