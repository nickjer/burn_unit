# frozen_string_literal: true

class RedrawRoundControlsJob < ApplicationJob
  queue_as :default

  # @param round [Round]
  # @return [void]
  def perform(round)
    return unless round.polling?

    PlayerChannel.broadcast_update_to(
      round.judge,
      target: "round_controls",
      partial: "completed_rounds/form",
      locals: { round: }
    )
  end
end
