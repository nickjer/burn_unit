# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game

  scope :active, -> { where(deleted_at: nil) }

  validates :name, length: { in: 3..20 }
  validates :name, uniqueness: {
    scope: %i[game deleted_at], case_sensitive: false
  }
  validates :user, uniqueness: {
    scope: %i[game deleted_at], message: "is already playing in this game"
  }
  validate :cannot_delete_participating_player

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

  # @return [Boolean]
  def active?
    deleted_at.blank?
  end

  # @return [Boolean]
  def readonly?
    if will_save_change_to_deleted_at?
      deleted_at_change_to_be_saved.first.present?
    else
      deleted_at.present?
    end
  end

  # @return [Participant, nil]
  def current_participant
    game.current_round.participants.find do |participant|
      participant.player_id == id
    end
  end

  # @return [Vote, nil]
  def current_vote
    return if current_participant.blank?

    current_participant.vote
  end

  # @param round [Round, nil]
  # @return [Boolean]
  def existed_since?(round)
    return false if round.blank?

    created_at < round.created_at
  end

  # @param round [Round, nil]
  # @return [Boolean]
  def played_in?(round)
    return false if round.blank?

    round.participants.any? { |participant| participant.player_id == id }
  end

  private

  # @return [void]
  def cannot_delete_participating_player
    return if deleted_at.blank? || !deleted_at_changed?
    return unless played_in?(game.current_round)

    errors.add(:base, "Cannot delete active or participating player")
  end
end
