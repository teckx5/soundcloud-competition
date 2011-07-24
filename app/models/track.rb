class Track < ActiveRecord::Base
  acts_as_voteable
  belongs_to :user
  belongs_to :competition, :counter_cache => true

  def self.identify_or_create_from_soundcloud(data)
    track_info = {
      :tid => data["id"],
      :title => data["title"],
      :permalink => data["permalink"],
      :artwork_url => data["artwork_url"],
      :waveform_url => data["waveform_url"],
      :secret_token => data["secret_token"]
    }

    if track = Track.find_by_tid(track_info[:tid])
      track.update_attributes!(track_info)
    else
      track = Track.create(track_info)
    end

    track
  end

  def previous
    Track.find(:first, :conditions => ["id < ?", id], :order => "id DESC") || Track.last
  end

  def next
    Track.find(:first, :conditions => ["id > ?", id], :order => "id ASC") || Track.first
  end
end
