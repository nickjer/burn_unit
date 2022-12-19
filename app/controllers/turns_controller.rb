# frozen_string_literal: true

class TurnsController < ApplicationController
  # GET /games/:game_id/turns/new
  def new
    @turn = TurnForm.new(game:, user: @user)
  end

  # POST /games/:game_id/turns
  def create
    @turn = TurnForm.new(game:, user: @user, **turn_params)

    if @turn.save
      redirect_to game_path(@turn.game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # @return [Game]
  def game
    @game ||= Game.find(params[:game_id])
  end

  # @return [Player, nil]
  def player
    @player ||= game.active_player_for(@user)
  end

  # @return [ActionController::Parameters]
  def turn_params
    params.require(:turn_form)
      .permit(round_attributes: %i[question least_likely hide_votes])
  end
end
