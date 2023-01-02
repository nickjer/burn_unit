# frozen_string_literal: true

class Game < ApplicationRecord
  enum status: { playing: 0, completed: 1 }

  has_many :players, dependent: :destroy
  has_many :rounds, -> { order(:order) }, dependent: :destroy, inverse_of: :game

  # @return [Array<Player>]
  def active_players
    players.select(&:active?)
  end

  # @return [Array<Player>]
  def active_players_since(num_rounds: 3)
    return active_players if rounds.size < num_rounds

    active_players.select do |player|
      rounds.last(num_rounds).any? do |round|
        !player.existed_since?(round) || player.played_in?(round)
      end
    end
  end

  # @param user [User]
  # @return [Player, nil]
  def active_player_for(user)
    active_players.find { |player| player.user == user }
  end

  # @return [Round, nil]
  def current_round
    rounds.last
  end

  # @return [Player, nil]
  def current_judge
    current_round&.judge
  end
end
