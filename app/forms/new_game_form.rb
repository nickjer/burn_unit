# frozen_string_literal: true

class NewGameForm < ApplicationForm
  # @return [Player]
  attr_reader :player

  # @return [Round]
  attr_reader :round

  # @return [Game]
  attr_reader :game

  # Validations
  validate :player_is_valid
  validate :round_is_valid

  # @param params [#to_h]
  def initialize(params = {})
    @player = Player.new
    @round = Round.new(
      judge: @player,
      participants: [Participant.new(player: @player)]
    )
    @game = Game.new(players: [@player], rounds: [@round])
    super(params)
  end

  delegate :attributes=, to: :player, prefix: :player
  delegate :attributes=, to: :round, prefix: :round

  # @return [Boolean]
  def save
    return false unless valid?

    game.save
  end

  private

  # @return [void]
  def player_is_valid
    return if player.valid?

    errors.add(:player, "is invalid")
  end

  # @return [void]
  def round_is_valid
    return if round.valid?

    errors.add(:round, "is invalid")
  end
end
