# frozen_string_literal: true

class NewPlayersController < ApplicationController
  # GET /games/:game_id/new_players/new
  def new
    @new_player = NewPlayerForm.new(game:, user: @user)
  end

  # POST /games/:game_id/new_players
  def create
    @new_player = NewPlayerForm.new(game:, user: @user, **new_player_params)

    if @new_player.save
      game.active_players.each do |player|
        next if player == @new_player.player

        PlayerChannel.broadcast_append_later_to(
          player,
          target: "vote_candidate_id",
          partial: "votes/candidate",
          locals: { candidate: @new_player.participant, selected: false }
        )
        PlayerChannel.broadcast_append_later_to(
          player,
          target: "players",
          partial: "players/player",
          locals: {
            player: @new_player.player, judge: game.current_judge, me: player
          }
        )
      end
      redirect_to game
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # @return [Game]
  def game
    @game ||= Game.find(params[:game_id])
  end

  # @return [ActionController::Parameters]
  def new_player_params
    params.require(:new_player_form).permit(player_attributes: %i[name])
  end
end
