# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.datetime :last_seen_at, null: false

      t.timestamps
    end
  end
end
