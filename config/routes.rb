Rails.application.routes.draw do
  devise_for :users

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  
  resources :transactions do
    collection do
      post :import
    end
  end

  root "transactions#index"
end