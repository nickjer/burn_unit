# frozen_string_literal: true

class CreateParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :participants, id: :uuid do |t|
      t.references :player, type: :uuid, null: false, foreign_key: true
      t.references :round, type: :uuid, null: false, foreign_key: true

      t.timestamps

      t.index %i[player_id round_id], unique: true
    end
  end
end
