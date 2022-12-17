# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games, id: :uuid do |t|
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
