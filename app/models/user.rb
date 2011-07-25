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
      :token => auth["credentials"]["token"],
      :secret => auth["credentials"]["secret"]
    }

    if user = User.find_by_uid(user_info[:uid])
      user.update_attributes!(user_info)
    else
      user = User.create(user_info)
    end

    user
  end

  def soundcloud
    consumer = OAuth::Consumer.new(Settings.key, Settings.secret, {:site => "https://api.soundcloud.com"})
    OAuth::AccessToken.new(consumer, token, secret)
  end

  def soundcloud_tracks
    MultiJson.decode(soundcloud.get('/me/tracks.json').body)
  end

  def soundcloud_groups
    groups = MultiJson.decode(soundcloud.get('/me/groups.json').body)
    groups.delete_if {|g| g["creator"]["id"] != uid }
  end

  def link
    "http://soundcloud.com/#{permalink}"
  end

  def is_admin?(competition)
    competition.user.nil? || competition.user == self
  end
end
