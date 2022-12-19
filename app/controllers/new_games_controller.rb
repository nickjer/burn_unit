# frozen_string_literal: true

class NewGamesController < ApplicationController
  # GET /new_games/new
  def new
    @new_game = NewGameForm.new(user: @user)
  end

  # POST /new_games
  def create
    @new_game = NewGameForm.new(user: @user, **new_game_params)

    if @new_game.save
      redirect_to game_path(@new_game.game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # @return [ActionController::Parameters]
  def new_game_params
    params.require(:new_game_form)
      .permit(
        player_attributes: %i[name],
        round_attributes: %i[question least_likely hide_votes]
      )
  end
end
