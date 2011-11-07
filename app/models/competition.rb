class Competition < ActiveRecord::Base
  belongs_to :user
  has_many :tracks

  def latest_tracks
    tracks.all(:limit => 3, :order => "created_at DESC")
  end

  def top_tracks
    tracks.plusminus_tally(:limit => 3)
  end
end
