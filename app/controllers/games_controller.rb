# frozen_string_literal: true

class GamesController < ApplicationController
  # GET /games/1
  def show
    game = Game.find(params[:id])

    if (current_player = game.active_player_for(@user))
      @game = GamePresenter.new(game:, current_player:)
    else
      redirect_to(new_game_player_path(game))
    end
  end
end
