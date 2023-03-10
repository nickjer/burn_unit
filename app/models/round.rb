# frozen_string_literal: true

class Round < ApplicationRecord
  enum status: { polling: 0, completed: 1 }

  belongs_to :judge, class_name: "Player"
  belongs_to :game

  has_many :participants, -> { includes(:player, :vote) }, dependent: :destroy,
    inverse_of: :round

  validates :question, length: { in: 3..160 }
  validates :game, uniqueness: { scope: :order }
  validate :judge_in_game
  validate :next_highest_order, on: :create
  validate :all_rounds_completed, on: :create

  # @return [Array<Vote>]
  def votes
    participants.map(&:vote).compact
  end

  # @return [Array<Participant>]
  def winning_candidates
    participants.group_by(&:total_votes).max.last
  end

  # @return [Array<Participant>]
  def ordered_candidates
    participants
      .sort_by { |candidate| [-candidate.total_votes, candidate.name] }
  end

  # @return [Boolean]
  def show_voters?
    !hide_voters?
  end

  # @return [Boolean]
  def tally_votes?
    votes.size > 1
  end

  private

  # @return [void]
  def judge_in_game
    return if game == judge.game

    errors.add(:judge, "does not exist in this game")
  end

  # @return [void]
  def next_highest_order
    highest_order = Round.where(game:).order(:order).last&.order
    return if highest_order.blank?
    return if (order - 1) == highest_order

    errors.add(:order, "must be the next highest integer")
  end

  # @return [void]
  def all_rounds_completed
    return unless game.rounds.not_completed.exists?

    errors.add(:base, "Active round currently exists for this game")
  end
end
