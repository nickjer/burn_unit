# frozen_string_literal: true

class CreateRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :rounds, id: :uuid do |t|
      t.references :game, type: :uuid, null: false, foreign_key: true
      t.references :judge, type: :uuid, null: false,
        foreign_key: { to_table: :players }
      t.integer :order, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.text :question
      t.boolean :least_likely, default: false, null: false
      t.boolean :hide_votes, default: false, null: false

      t.timestamps

      t.index %i[game_id order], unique: true
    end
  end
end
