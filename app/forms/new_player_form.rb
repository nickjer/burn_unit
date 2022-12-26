# frozen_string_literal: true

class NewPlayerForm < ApplicationForm
  # @return [Player]
  attr_reader :player

  # @return [Participant, nil]
  attr_reader :participant

  # Validations
  validate :player_is_valid
  validate :participant_is_valid

  # @param game [Game]
  # @param user [User]
  # @param params [#to_h]
  def initialize(game:, user:, **params)
    @player = Player.new(game:, user:)

    current_round = game.current_round
    if current_round.polling?
      @participant = Participant.new(player:, round: current_round)
    end

    super(params)
  end

  # @!method game
  #   @return [Game]
  delegate :game, to: :player

  # @!method player_attributes=(new_attributes)
  #   @param new_attributes [#each_pair]
  #   @return [void]
  delegate :attributes=, to: :player, prefix: :player

  # @return [Boolean]
  def save
    return false unless valid?

    player.save && (participant.blank? || participant.save)
  end

  private

  # @return [void]
  def player_is_valid
    return if player.valid?

    errors.add(:player, "is invalid")
  end

  # @return [void]
  def participant_is_valid
    return if participant.blank? || participant.valid?

    errors.add(:participant, "is invalid")
  end
end
