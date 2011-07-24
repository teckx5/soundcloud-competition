class TracksController < ApplicationController

  before_filter :load_competition, :only => [:index, :show, :new]

  def index
    @tracks = Track.all
  end

  def show
    @track = Track.find(params[:id])
  end

  def new
    @track = @competition.tracks.new
  end

  def create
    track = MultiJson.decode(current_user.soundcloud.get("/tracks/#{params[:track][:tid]}.json").body)
    current_user.soundcloud.put("/groups/33135/contributions/#{params[:track][:tid]}")
    @track = current_user.tracks.identify_or_create_from_soundcloud(track)
    redirect_to @track
  end

  def favorite
    @track = Track.find(params[:id])

    if request.method == "PUT"
      res = current_user.soundcloud.put("/me/favorites/#{@track.tid}.json").body
    elsif request.method == "DELETE"
      res = current_user.soundcloud.delete("/me/favorites/#{@track.tid}.json").body
    else
      res = current_user.soundcloud.get("/me/favorites/#{@track.tid}.json").body
    end

    render :json => res
  end

  def destroy
    @track = Track.find(params[:id])
    @track.destroy
    redirect_to root_path
  end

  def load_competition
    @competition = Competition.first
  end
end
