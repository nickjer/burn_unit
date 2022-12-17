# frozen_string_literal: true

class User < ApplicationRecord
  has_many :players, dependent: :destroy
end
