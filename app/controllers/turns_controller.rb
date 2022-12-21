# frozen_string_literal: true

class TurnsController < ApplicationController
  # GET /players/:player_id/turns/new
  def new
    @turn = TurnForm.new(judge: player)
  end

  # POST /players/:player_id/turns
  def create
    @turn = TurnForm.new(judge: player, **turn_params)

    if @turn.save
      redirect_to game_path(@turn.game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # @return [Player]
  def player
    @player ||= Player.where(user: @user).find(params[:player_id])
  end

  # @return [ActionController::Parameters]
  def turn_params
    params.require(:turn_form)
      .permit(round_attributes: %i[question least_likely hide_votes])
  end
end
