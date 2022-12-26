# frozen_string_literal: true

class TurnForm < ApplicationForm
  # @return [Round]
  attr_reader :round

  # @return [Round]
  attr_reader :previous_round

  # Validations
  validates :previous_round_status, inclusion: { in: %w[completed] }
  validate :round_is_valid

  # @param judge [Player]
  # @param params [#to_h]
  def initialize(judge:, **params)
    @previous_round = judge.game.current_round

    participants = judge.game.active_players
      .map { |player| Participant.new(player:) }
    @round = Round.new(
      game: judge.game,
      judge:,
      participants:,
      hide_voters: previous_round.hide_voters,
      order: previous_round.order + 1
    )
    super(params)
  end

  # @!method judge
  #   @return [Player]
  delegate :judge, to: :round

  # @!method game
  #   @return [Game]
  delegate :game, to: :round

  # @!method round_attributes=(new_attributes)
  #   @param new_attributes [#each_pair]
  #   @return [void]
  delegate :attributes=, to: :round, prefix: :round

  # @return [Boolean]
  def save
    return false unless valid?

    round.save
  end

  private

  def previous_round_status
    previous_round.status
  end

  # @return [void]
  def round_is_valid
    return if round.valid?

    errors.add(:round, "is invalid")
  end
end
