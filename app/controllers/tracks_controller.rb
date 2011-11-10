class TracksController < ApplicationController

  before_filter :load_competition, :except => [:favorite]

  def index
    @tracks = Track.order("created_at DESC").page(params[:page]).per(10)
  end

  def show
    @track = Track.find(params[:id])
  end

  def new
    if Time.now < @competition.end_date
      @track = @competition.tracks.new
    else
      redirect_to root_path
    end
  end
  
  def create
    track = current_user.soundcloud.get("/tracks/#{params[:track][:tid]}.json")    
    @track = current_user.tracks.identify_or_create_from_soundcloud(track)    
    respond_to do |format|
      format.html { redirect_to @track, notice: 'Track was successfully submitted.' }
      format.json { render json: @track, status: :created, location: @track }
    end
  end

  def destroy
    @track = Track.find(params[:id])
    @track.destroy
    redirect_to root_path
  end
  
  # Favorite

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
  
  # Record
  
  def record
    render :text => "https://api.soundcloud.com/tracks.json?oauth_token=#{current_user.token}"
  end

  private

  def load_competition
    @competition = Competition.first
  end
end
