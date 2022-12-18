# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  resources :new_games, only: %i[create new]

  root "new_games#new"

  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?
end
