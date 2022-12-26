# frozen_string_literal: true

class TurnForm < ApplicationForm
  # @return [Round]
  attr_reader :round

  # @return [Round]
  attr_reader :previous_round

  # @return [Array<Player>]
  attr_reader :participating_players

  # Validations
  validates :previous_round_status, inclusion: { in: %w[completed] }
  validate :round_is_valid

  # @param judge [Player]
  # @param params [#to_h]
  def initialize(judge:, **params)
    game = judge.game
    @previous_round = game.current_round

    @participating_players = game.active_players_since(num_rounds: 3)
    @round = Round.new(
      game: judge.game,
      judge:,
      participants:
        participating_players.map { |player| Participant.new(player:) },
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

    round.save &&
      inactive_players.all? do |inactive_player|
        inactive_player.update(deleted_at: Time.current)
      end
  end

  private

  # @return [String]
  def previous_round_status
    previous_round.status
  end

  # @return [Array]
  def inactive_players
    game.active_players.difference(participating_players)
  end

  # @return [void]
  def round_is_valid
    return if round.valid?

    errors.add(:round, "is invalid")
  end
end
