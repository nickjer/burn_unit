# frozen_string_literal: true

class PlayersController < ApplicationController
  # GET /players/:id/edit
  def edit
    @player = Player.where(user: @user).find(params[:id])
  end

  # PATCH/PUT /players/:id
  def update
    @player = Player.where(user: @user).find(params[:id])

    if @player.update(player_params)
      @player.game.active_players.each do |participating_player|
        PlayerChannel.broadcast_update_to(
          participating_player,
          targets: "#player_#{@player.id} .player-name",
          html: @player.name
        )
      end

      game_presenter =
        GamePresenter.new(game: @player.game, current_player: @player)
      RedrawCurrentRoundJob.perform_later(@player.game, except_to: @player)
      render(
        turbo_stream: turbo_stream.update("main",
          partial: "games/current_round", locals: { game: game_presenter })
      )
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # @return [Game]
  def game
    @game ||= Game.find(params[:game_id])
  end

  # @return [ActionController::Parameters]
  def player_params
    params.require(:player).permit(:name)
  end
end
