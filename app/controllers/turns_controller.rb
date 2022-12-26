# frozen_string_literal: true

class TurnsController < ApplicationController
  # GET /players/:player_id/turns/new
  def new
    @turn = TurnForm.new(judge: current_player)
  end

  # POST /players/:player_id/turns
  def create
    @turn = TurnForm.new(judge: current_player, **turn_params)

    if @turn.save
      game = Game.find(@turn.game.id) # work from latest data

      # Show the Next Turn link to all other players
      game.players.each do |player|
        next if player == current_player

        PlayerChannel.broadcast_update_to(
          player,
          target: "new_turn",
          partial: "games/current_round_link",
          locals: { game: }
        )
      end

      RedrawPlayersJob.perform_later(game)

      game_presenter = GamePresenter.new(game:, current_player:)
      render(
        turbo_stream: turbo_stream.update("main",
          partial: "games/current_round", locals: { game: game_presenter })
      )
    else
      render :create, status: :unprocessable_entity
    end
  end

  private

  # @return [Player]
  def current_player
    @current_player ||= Player.where(user: @user).find(params[:player_id])
  end

  # @return [ActionController::Parameters]
  def turn_params
    params.require(:turn_form)
      .permit(round_attributes: %i[question least_likely hide_voters])
  end
end
