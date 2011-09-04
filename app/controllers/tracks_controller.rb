class TracksController < ApplicationController

  before_filter :load_competition, :except => [:favorite]

  def index
    @tracks = Track.order("created_at DESC").page(params[:page]).per(10)
  end

  def show
    @track = Track.find(params[:id])
  end

  def new
    @track = @competition.tracks.new
  end

  def create
    track = current_user.soundcloud.get("/tracks/#{params[:track][:tid]}.json")
    @track = current_user.tracks.identify_or_create_from_soundcloud(track)
    redirect_to @track
  end

  def destroy
    @track = Track.find(params[:id])
    @track.destroy
    redirect_to root_path
  end

  def favorite
    @track = Track.find(params[:id])

    if request.method == "PUT"
      res = current_user.soundcloud.put("/me/favorites/#{@track.tid}.json")
    elsif request.method == "DELETE"
      res = current_user.soundcloud.delete("/me/favorites/#{@track.tid}.json")
    else
      res = current_user.soundcloud.get("/me/favorites/#{@track.tid}.json")
    end

    render :json => res
  end

  private

  def load_competition
    @competition = Competition.first
  end
end
