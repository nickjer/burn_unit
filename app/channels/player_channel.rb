# frozen_string_literal: true

class PlayerChannel < ApplicationCable::Channel
  extend Turbo::Streams::StreamName
  extend Turbo::Streams::Broadcasts
  include Turbo::Streams::StreamName::ClassMethods

  class << self
    # @param player [Player]
    # @return [Boolean]
    def subscribed?(player)
      pubsub = ActionCable.server.pubsub

      channel_name = pubsub.send(:channel_with_prefix, stream_name_from(player))
      subscriptions = pubsub
        .redis_connection_for_subscriptions
        .pubsub("channels", channel_name)

      subscriptions.present?
    end
  end

  # @return [void]
  def subscribed
    if player.present? && player.user == current_user
      stream_from stream_name
      broadcast_player_to_game
    else
      reject
    end
  end

  # @return [void]
  def unsubscribed
    stop_stream_from stream_name
    broadcast_player_to_game
  end

  private

  # @return [String, nil]
  def stream_name
    @stream_name ||= verified_stream_name_from_params
  end

  # @return [Player, nil]
  def player
    return if stream_name.blank?

    @player ||= GlobalID.find(stream_name)
  end

  # @return [void]
  def broadcast_player_to_game
    # Reload cache, in particular the instance variables
    game = Game.find(player.game_id)

    game.active_players.each do |other_player|
      next if other_player == player

      self.class.broadcast_update_later_to(
        other_player,
        targets: player.selector_for(:online),
        partial: "players/online",
        locals: { online: player.online? }
      )
    end
  end
end
