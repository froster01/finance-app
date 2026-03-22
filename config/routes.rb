Rails.application.routes.draw do
  devise_for :users

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # Sidekiq Web UI - monitoring for background jobs
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :transactions do
    collection do
      post :import
    end
  end

  root "transactions#index"
end