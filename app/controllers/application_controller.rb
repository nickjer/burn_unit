# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_user

  private

  # @return [void]
  def require_user
    @user = User.find_by(id: current_user_id) || User.new
    @user.update!(last_seen_at: Time.current)
    self.current_user_id = @user.id.to_s
  end

  # @return [String, nil]
  def current_user_id
    cookies.encrypted[:current_user_id].to_s.presence
  end

  # @param user_id [#to_s]
  # @return [void]
  def current_user_id=(user_id)
    cookies.permanent.encrypted[:current_user_id] = user_id.to_s
  end
end
