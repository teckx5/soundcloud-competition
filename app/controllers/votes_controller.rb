class VotesController < ApplicationController
  def create
    vote = params[:vote]
    track = Track.find_by_tid(vote[:track_id])
    current_user.clear_votes(track)
    vote[:vote] == "true" ? current_user.vote_for(track) : current_user.vote_against(track)
    render :json => vote[:vote]
  end
end
