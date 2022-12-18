# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :voter, class_name: "Participant", inverse_of: :vote
  belongs_to :candidate, class_name: "Participant"

  validates :voter, uniqueness: true
  validate :cannot_vote_for_self
  validate :must_be_in_same_round

  private

  # @return [void]
  def cannot_vote_for_self
    return if voter != candidate

    errors.add(:candidate, "Cannot be same as voter")
  end

  # @return [void]
  def must_be_in_same_round
    return if voter.round == candidate.round

    errors.add(:candidate, "Must be in the same round as voter")
  end
end
