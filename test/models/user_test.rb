# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "#valid? returns false if missing last_seen_at" do
    user = User.new

    assert_not_predicate user, :valid?
    assert user.errors.added?(:last_seen_at, :blank)
  end
end
