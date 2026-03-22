Rails.application.routes.draw do
  devise_for :users
  
  resources :transactions do
    collection do
      post :import
    end
  end

  root "transactions#index"
end