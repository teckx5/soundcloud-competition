class CommentsController < ApplicationController
  def create
    res = current_user.soundcloud.post("/tracks/#{params[:comment][:track_id]}/comments.json", {"comment[body]" => params[:comment][:body], "consumer_key" => Settings.key}).body
    render :json => res
  end
end
