# frozen_string_literal: true

module FormModel
  extend ActiveSupport::Concern

  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  include LogValidations
end
