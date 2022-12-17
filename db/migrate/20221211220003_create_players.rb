# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players, id: :uuid do |t|
      t.string :name
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :game, type: :uuid, null: false, foreign_key: true
      t.datetime :deleted_at, null: true

      t.timestamps

      t.index :deleted_at
      t.index %i[user_id game_id deleted_at], unique: true
      t.index %i[name game_id deleted_at], unique: true
    end
  end
end
