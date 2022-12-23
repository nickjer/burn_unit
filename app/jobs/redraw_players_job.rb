# frozen_string_literal: true

class RedrawPlayersJob < ApplicationJob
  queue_as :default

  # @param game [Game]
  # @return [void]
  def perform(game)
    game.active_players.each do |player|
      PlayerChannel.broadcast_update_to(
        player,
        target: "players",
        collection: game.active_players,
        partial: "players/player",
        locals: { judge: game.current_judge, me: player }
      )
    end
  end
end
