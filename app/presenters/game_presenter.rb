# frozen_string_literal: true

class GamePresenter
  # @return [Game]
  attr_reader :game

  # @return [Player]
  attr_reader :current_player

  # @param game [Game]
  # @param current_player [Player]
  def initialize(game:, current_player:)
    @game = game
    @current_player = current_player

    raise "Game presenter needs a current round to draw" if current_round.blank?
  end

  # @!method to_param
  #   @return [String]
  delegate :to_param, to: :game

  # @!method current_round
  #   @return [Round]
  delegate :current_round, to: :game

  # @!method players
  #   @return [Array<Player>]
  delegate :active_players, to: :game

  # @!method current_judge
  #   @return [Player]
  delegate :current_judge, to: :game

  # @!method polling?
  #   @return [Boolean]
  delegate :polling?, to: :current_round

  # @!method completed?
  #   @return [Boolean]
  delegate :completed?, to: :current_round

  # @return [Boolean]
  def current_player_is_judge?
    current_player == current_judge
  end

  # @return [Participant, nil]
  def current_participant
    return unless polling?

    @current_participant ||=
      current_round.participants.find_or_initialize_by(player: current_player)
  end

  # @return [Vote, nil]
  def current_participant_vote
    return if current_participant.blank? || current_participant.new_record?

    @current_participant_vote ||=
      current_participant.vote.presence || current_participant.build_vote
  end
end
