# frozen_string_literal: true

class Participant < ApplicationRecord
  belongs_to :player
  belongs_to :round

  has_one :vote, dependent: :destroy

  validates :player, uniqueness: { scope: :round }
end
