# frozen_string_literal: true

class Participant < ApplicationRecord
  belongs_to :player
  belongs_to :round

  has_one :vote, dependent: :destroy, foreign_key: :voter_id, inverse_of: :voter

  validates :player, uniqueness: { scope: :round }
  validate :player_in_game

  # @return [String]
  def to_label
    player.name
  end

  private

  # @return [void]
  def player_in_game
    return if round.game == player.game

    errors.add(:player, "not in same game as round")
  end
end
