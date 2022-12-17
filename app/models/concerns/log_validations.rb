# frozen_string_literal: true

module LogValidations
  extend ActiveSupport::Concern

  included { after_validation :log_validations }

  # @return [void]
  def log_validations
    return if errors.blank?

    error_messages =
      errors.full_messages.map { |msg| "    => #{msg}" }.join("\n")
    Rails.logger.tagged("VALIDATION") do
      Rails.logger.error("#{inspect}\n#{error_messages}")
    end
  end
end
