# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes, id: :uuid do |t|
      t.references :voter, type: :uuid, null: false,
        foreign_key: { to_table: :participants }, index: { unique: true }
      t.references :candidate, type: :uuid, null: false,
        foreign_key: { to_table: :participants }

      t.timestamps
    end
  end
end
