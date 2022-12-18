# frozen_string_literal: true

class RedrawCurrentRoundJob < ApplicationJob
  queue_as :default

  # @param game [Game]
  # @param except_to [Player, nil]
  # @return [void]
  def perform(game, except_to: nil)
    game.active_players.each do |player|
      next if player == except_to

      game_presenter = GamePresenter.new(game:, current_player: player)
      PlayerChannel.broadcast_update_to(
        player,
        target: "main",
        partial: "games/current_round",
        locals: { game: game_presenter }
      )
    end
  end
end
