# frozen_string_literal: true

class Game < ApplicationRecord
  enum status: { playing: 0, completed: 1 }

  has_many :players, dependent: :destroy
  has_many :rounds, -> { order(:order) }, dependent: :destroy, inverse_of: :game

  # @return [Array<Player>]
  def active_players
    players.select(&:active?)
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

  # @return [Array<Player>]
  def inactive_players(num_rounds: 3)
    @inactive_players ||=
      begin
        player_list = players.to_a.dup

        num_rounds.times.reduce(current_round) do |round, _index|
          next round if round.blank?

          player_list.delete_if do |player|
            !player.existed_since?(round) || player.played_in?(round)
          end
          round.previous
        end

        player_list
      end
  end
end
