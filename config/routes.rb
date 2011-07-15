SoundcloudSubmit::Application.routes.draw do

  resources :tracks

  match "/tracks/:id/favorite" => 'tracks#favorite', :as => :favorite_track
  match "/submit" => 'tracks#new'

  match "/votes" => 'votes#create', :via => :post
  match "/comments" => 'comments#create', :via => :post

  match "/login" => 'sessions#new', :as => :login
  match "/logout" => 'sessions#destroy', :as => :logout
  match "/auth/soundcloud/callback"  => "sessions#create"

  root :to => 'tracks#index'

end
