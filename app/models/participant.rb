# frozen_string_literal: true

class Participant < ApplicationRecord
  belongs_to :player
  belongs_to :round

  has_one :vote, -> { includes(:voter, :candidate) }, dependent: :destroy,
    foreign_key: :voter_id, inverse_of: :voter

  validates :player, uniqueness: { scope: :round }
  validate :player_in_game

  # @!method name
  #   @return [String]
  delegate :name, to: :player

  # @return [String]
  def to_label
    player.name
  end

  # @return [Array<Vote>]
  def votes
    round.votes.select { |vote| vote.candidate == self }
  end

  # @return [Array<Participant>]
  def voters
    votes.map(&:voter).sort_by(&:to_label)
  end

  # @return [Integer]
  def total_votes
    votes.size
  end

  private

  # @return [void]
  def player_in_game
    return if round.game == player.game

    errors.add(:player, "not in same game as round")
  end
end
