class User < ActiveRecord::Base
  acts_as_voter
  has_many :tracks

  def self.identify_or_create_from_omniauth(auth)
    user_info = {
      :uid => auth["uid"],
      :name => auth["user_info"]["name"],
      :username => auth["extra"]["user_hash"]["username"],
      :permalink => auth["extra"]["user_hash"]["permalink"],
      :avatar_url => auth["user_info"]["image"],
      :city => auth["extra"]["user_hash"]["city"],
      :country => auth["extra"]["user_hash"]["country"],
      :token => auth["credentials"]["token"]
    }

    if user = User.find_by_uid(user_info[:uid])
      user.update_attributes!(user_info)
    else
      user = User.create(user_info)
    end

    user
  end

  def soundcloud
    Soundcloud.new(:client_id => Settings.key, :client_secret => Settings.secret, :access_token => token)
  end

  def soundcloud_tracks
    tracks = soundcloud.get('/me/tracks.json')
    tracks.delete_if {|t| t["sharing"] != "public" }
  end

  def soundcloud_groups
    groups = soundcloud.get('/me/groups.json')
    groups.delete_if {|g| g["creator"]["id"] != uid }
  end

  def link
    "http://soundcloud.com/#{permalink}"
  end

  def is_admin?(competition)
    competition.user.nil? || competition.user == self
  end
end
