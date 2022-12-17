# frozen_string_literal: true

class Game < ApplicationRecord
  enum status: { playing: 0, completed: 1 }

  has_many :players, dependent: :destroy
  has_many :rounds, through: :players

  # @return [Round, nil]
  def current_round
    @current_round ||= rounds.current.first
  end

  # @return [Player, nil]
  def active_player
    @active_player ||= current_round&.player
  end

  # @return [Array<Answer>]
  def current_answers
    @current_answers ||= current_round&.answers.to_a
  end

  # @return [Array<Player>]
  def inactive_players(num_rounds: 3)
    @inactive_players ||=
      begin
        player_list = players.to_a.dup

        num_rounds.times.reduce(current_round) do |round, _index|
          next round if round.blank?

          player_list.delete_if do |player|
            !player.existed_in?(round) || player.played_in?(round)
          end
          round.previous
        end

        player_list
      end
  end
end
