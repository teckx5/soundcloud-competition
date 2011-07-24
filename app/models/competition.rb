class Competition < ActiveRecord::Base
  belongs_to :user
  has_many :tracks

  def latest_tracks
    self.tracks.all(:limit => 3, :order => "created_at DESC")
  end

  def top_tracks
    self.tracks.rank_tally(:limit => 3)
  end
end
