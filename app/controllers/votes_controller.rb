# frozen_string_literal: true

class VotesController < ApplicationController
  # POST /participants/:participant_id/votes
  def create
    participant = Participant.where(
      player: Player.active.where(user: @user),
      round: Round.polling
    ).find(params[:participant_id])

    @vote = participant.build_vote(vote_params)

    if @vote.save
      RedrawRoundControlsJob.perform_later(participant.round)
      RedrawPlayerJob.perform_later(participant.player)
      render :update
    else
      render :create, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /votes/:id
  def update
    @vote = Vote.where(
      voter: Participant.where(
        player: Player.active.where(user: @user),
        round: Round.polling
      )
    ).find(params[:id])

    if @vote.update(vote_params)
      render :update
    else
      render :update, status: :unprocessable_entity
    end
  end

  private

  # @return [ActionController::Parameters]
  def vote_params
    params.require(:vote).permit(:candidate_id)
  end
end
