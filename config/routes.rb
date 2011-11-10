SoundCloudCompetition::Application.routes.draw do

  resources :competitions

  resources :tracks do
    get '/page/:page', :action => :index, :on => :collection
  end

  match "/admin" => 'competitions#edit', :id => 1, :as => :admin

  match "/tracks/:id/favorite" => 'tracks#favorite', :as => :favorite_track
  match "/submit" => 'tracks#new'
  match "/record" => 'tracks#record'

  match "/votes" => 'votes#create', :via => :post
  match "/comments" => 'comments#create', :via => :post

  match "/login" => 'sessions#new', :as => :login
  match "/logout" => 'sessions#destroy', :as => :logout
  match "/auth/soundcloud/callback"  => "sessions#create"

  root :to => 'competitions#show', :id => 1

end
