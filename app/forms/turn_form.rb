# frozen_string_literal: true

class TurnForm < ApplicationForm
  # @return [Round]
  attr_reader :round

  # @return [Round]
  attr_reader :previous_round

  # @return [Game]
  attr_reader :game

  # Validations
  validates :previous_round_status, inclusion: { in: %w[completed] }
  validate :round_is_valid

  # @param game [Game]
  # @param user [User]
  # @param params [#to_h]
  def initialize(game:, user:, **params)
    @game = game
    @previous_round = game.current_round

    player = game.active_player_for!(user)
    @round = Round.new(
      game:,
      judge: player,
      participants: [Participant.new(player:)],
      hide_votes: previous_round.hide_votes,
      order: previous_round.order + 1
    )
    super(params)
  end

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
