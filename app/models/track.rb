class Track < ActiveRecord::Base
  attr_accessor :agreed
  acts_as_voteable
  belongs_to :user
  belongs_to :competition, :counter_cache => true
  after_create :add_to_group
  before_destroy :remove_from_group

  def self.identify_or_create_from_soundcloud(data)
    track_info = {
      :tid => data["id"],
      :title => data["title"],
      :permalink => data["permalink"],
      :artwork_url => data["artwork_url"],
      :waveform_url => data["waveform_url"],
      :secret_token => data["secret_token"],
      :competition_id => 1
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

  private

  def add_to_group
    begin
      user.soundcloud.put("/groups/#{competition.group}/contributions/#{tid}") if competition.group
    rescue SoundCloud::ResponseError
      puts "Could not put track in group."
    end
  end

  def remove_from_group
    begin
      user.soundcloud.delete("/groups/#{competition.group}/contributions/#{tid}") if competition.group
    rescue Soundcloud::ResponseError
      puts "Track was not in group."
    end
  end
end
