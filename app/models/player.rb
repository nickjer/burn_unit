# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game

  has_many :rounds, dependent: :destroy
  has_many :answers, dependent: :destroy

  validates :name, length: { in: 3..20 }
  validates :name, uniqueness: {
    scope: %i[game deleted_at], case_sensitive: false
  }
  validates :game, uniqueness: {
    scope: %i[user deleted_at], message: "Player already exists for this game"
  }
  validate :cannot_delete_participating_player

  default_scope { where(deleted_at: nil) }
  scope :active, -> { joins(:rounds).merge(Round.current) }

  # @return [Boolean]
  def online?
    PlayerChannel.subscribed?(self)
  end

  # @param value [String, nil]
  # @return [void]
  def name=(value)
    normalized_value = value.to_s.unicode_normalize(:nfkc).squish
    super(normalized_value.gsub(/\P{Print}|\p{Cf}/, "").presence)
  end

  # @return [Answer, nil]
  def current_answer
    @current_answer ||=
      game.current_answers.find do |current_answer|
        id == current_answer.player_id
      end
  end

  # @return [Answer, nil]
  def guessed_answer
    @guessed_answer ||=
      game.current_answers.find do |current_answer|
        id == current_answer.guessed_player_id
      end
  end

  # @param round [Round, nil]
  # @return [Boolean]
  def existed_in?(round)
    return false if round.blank?

    created_at < round.created_at
  end

  # @param round [Round, nil]
  # @return [Boolean]
  def played_in?(round)
    return false if round.blank?

    was_active_player = (round.player_id == id)
    was_participating_player =
      round.answers.any? { |answer| answer.player_id == id }

    was_active_player || was_participating_player
  end

  private

  # @return [void]
  def cannot_delete_participating_player
    return if deleted_at.blank? || !deleted_at_changed?
    return unless played_in?(game.current_round)

    errors.add(:base, "Cannot delete active or participating player")
  end
end
