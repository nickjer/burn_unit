# frozen_string_literal: true

class PlayersController < ApplicationController
  # GET /games/:game_id/players/new
  def new
    @player = game.players.where(user: @user).build
  end

  # GET /players/:id/edit
  def edit
    @player = Player.where(user: @user).find(params[:id])
  end

  # POST /games/:game_id/players
  def create
    @player = game.players.where(user: @user).build(player_params)

    if @player.save
      game.active_players.each do |player|
        next if player == @player

        PlayerChannel.broadcast_append_later_to(
          player,
          target: "players",
          partial: "players/player",
          locals: {
            player: @player, judge: game.current_judge, me: player
          }
        )
      end
      redirect_to game
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /players/:id
  def update
    @player = Player.where(user: @user).find(params[:id])

    if @player.update(player_params)
      RedrawPlayerJob.perform_later(@player)

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
