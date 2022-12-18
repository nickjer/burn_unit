# frozen_string_literal: true

class RedrawPlayerJob < ApplicationJob
  queue_as :default

  # @param player_to_redraw [Player]
  # @return [void]
  def perform(player_to_redraw)
    game = player_to_redraw.game
    game.active_players.each do |player|
      PlayerChannel.broadcast_replace_to(
        player,
        target: player_to_redraw,
        partial: "players/player",
        locals: {
          player: player_to_redraw, judge: game.current_judge, me: player
        }
      )
    end
  end
end
