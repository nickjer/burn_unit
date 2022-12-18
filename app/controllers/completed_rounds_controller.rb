# frozen_string_literal: true

class CompletedRoundsController < ApplicationController
  # POST /rounds/:round_id/completed_rounds
  def create
    round = Round.where(judge: Player.active.where(user: @user))
      .find(params[:round_id])

    if CompleteRound.new(round:).call
      game = Game.find(round.game.id) # work from latest data
      status = :created
      RedrawCurrentRoundJob.perform_later(game, except_to: round.judge)
    else
      game = round.game
      status = :unprocessable_entity
    end

    @game = GamePresenter.new(game:, current_player: round.judge)
    render :create, status:
  end
end
