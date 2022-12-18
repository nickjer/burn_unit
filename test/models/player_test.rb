# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class PlayerTest < ActiveSupport::TestCase
  test "#valid? returns false if name is too short" do
    name = "Ab"
    player = Player.new(user: create_user, game: create_game, name:)

    assert_not_predicate player, :valid?
    assert player.errors.added?(:name, :too_short, count: 3)
  end

  test "#valid? returns false if name is too long" do
    name = "Abcdefghijklmnopqrstuvwxyz"
    player = Player.new(user: create_user, game: create_game, name:)

    assert_not_predicate player, :valid?
    assert player.errors.added?(:name, :too_long, count: 20)
  end

  test "#valid? returns false if another player in game has that name" do
    name = "Bob"
    game = create_game
    Player.create!(user: create_user, game:, name:)
    player = Player.new(user: create_user, game:, name:)

    assert_not_predicate player, :valid?
    assert player.errors.added?(:name, :taken, value: "Bob")
  end

  test "#valid? returns true if a deleted player in game has that name" do
    name = "Bob"
    game = create_game
    Player.create!(user: create_user, game:, name:, deleted_at: Time.current)
    player = Player.new(user: create_user, game:, name:)

    assert_predicate player, :valid?
  end

  test "#valid? returns false if user attempts to make another player " \
    "within same game" do
    game = create_game
    user = create_user
    Player.create!(user:, game:, name: "Bob 1")
    player = Player.new(user:, game:, name: "Bob 2")

    assert_not_predicate player, :valid?
    assert_equal ["User is already playing in this game"],
      player.errors.full_messages
  end

  test "#active? returns true if not deleted" do
    player = Player.create!(user: create_user, game: create_game, name: "Bob")

    assert_predicate player, :active?
  end

  test "#active? returns false if deleted" do
    player = Player.create!(
      user: create_user,
      game: create_game,
      name: "Bob",
      deleted_at: Time.current
    )

    assert_not_predicate player, :active?
  end

  [
    ["  Bob \n   Jones\t ", "Bob Jones"],
    ["B\x00ob", "Bob"],
    ["B\xEF\xBB\xBFob", "Bob"],
    ["❤️ Heart", "❤️ Heart"]
  ].each do |bad_name, good_name|
    test "#name sanitizes #{bad_name.inspect}" do
      player = Player.new(user: create_user, game: create_game, name: bad_name)

      assert_equal good_name, player.name
    end
  end

  test "#online? delegates out to the player channel" do
    player = Player.create!(user: create_user, game: create_game, name: "Bob")

    PlayerChannel.stub(:subscribed?, "RESULT") do
      assert_equal "RESULT", player.online?
    end
  end

  private

  # @param last_seen_at [Time, nil]
  # @return [User]
  def create_user(last_seen_at: Time.current)
    User.create!(last_seen_at:)
  end

  # @param status [Symbol, nil]
  # @return [Game]
  def create_game(status: :playing)
    Game.create!(status:)
  end
end
