# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :voter, class_name: "Participant", inverse_of: :vote
  belongs_to :candidate, class_name: "Participant"

  validates :voter, uniqueness: true
  validate :cannot_vote_for_self
  validate :must_be_in_same_round

  # @return [Array<Participant>]
  def possible_candidates
    voter.round.participants
      .reject { |participant| participant == voter }
      .sort_by(&:to_label)
  end

  private

  # @return [void]
  def cannot_vote_for_self
    return if voter != candidate

    errors.add(:candidate, "cannot be same as voter")
  end

  # @return [void]
  def must_be_in_same_round
    return if candidate.blank?
    return if voter.round == candidate.round

    errors.add(:candidate, "must be in the same round as voter")
  end
end
