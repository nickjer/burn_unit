# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include LogValidations

  primary_abstract_class
end
