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
          targets: @player.selector_for(:name),
          html: @player.name
        )
      end

      redirect_to @player.game
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
