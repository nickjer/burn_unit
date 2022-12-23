# frozen_string_literal: true

class ParticipantsController < ApplicationController
  # POST /rounds/:round_id/participants
  def create
    round = Round.where(
      game: Game.where(players: Player.active.where(user: @user))
    ).find(params[:round_id])

    return redirect_to(round.game) unless round.polling?

    player = round.game.active_player_for(@user)
    participant = round.participants.build(player:)

    if participant.save
      game = Game.find(round.game.id) # work from latest data
      status = :created
      RedrawCurrentRoundJob.perform_later(game, except_to: player)
    else
      game = round.game
      status = :unprocessable_entity
    end

    @game = GamePresenter.new(game:, current_player: player)
    render :create, status:
  end
end
