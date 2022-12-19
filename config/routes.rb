# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  resources :games, only: %i[show], shallow: true do
    resources :players, only: %i[create edit new update]
    resources :turns, only: %i[create new]
    resources :rounds, only: %i[show], shallow: true do
      resources :completed_rounds, only: %i[create]
      resources :participants, only: %i[create], shallow: true do
        resources :votes, only: %i[create update]
      end
    end
  end

  resources :new_games, only: %i[create new]

  root "new_games#new"

  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?
end
