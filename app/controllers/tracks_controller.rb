class TracksController < ApplicationController

  def index
    @latest_tracks = Track.all(:limit => 3, :order => "created_at DESC")
    @top_tracks = Track.rank_tally({:limit => 3})

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tracks }
    end
  end

  def show
    @track = Track.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @track }
    end
  end

  def new
    @track = Track.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @track }
    end
  end

  def create
    track = MultiJson.decode(current_user.soundcloud.get("/tracks/#{params[:track][:tid]}.json").body)
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

=begin

  def destroy
    @track = Track.find(params[:id])
    @track.destroy

    respond_to do |format|
      format.html { redirect_to tracks_url }
      format.json { head :ok }
    end
  end

=end

end
