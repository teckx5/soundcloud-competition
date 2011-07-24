class Competition < ActiveRecord::Base
  belongs_to :user
  has_many :tracks

  def latest_tracks
    Track.all(:conditions => {:competition_id => self.id}, :limit => 3, :order => "created_at DESC")
  end

  def top_tracks
    Track.rank_tally(:conditions => {:competition_id => self.id}, :limit => 3)
  end
end
