namespace :competition do
  desc "Import tracks from SoundCloud Group"
  task :import => :environment do
    
    # rake competition:import GROUP=http://soundcloud.com/groups/test
    
    @group = HTTParty.get("http://api.soundcloud.com/resolve?url=#{ENV["GROUP"]}&consumer_key=#{Settings.key}&format=json")
    
    if @group.response.code == "404"
      
      puts "Group Not Found"
    
    else  
      
      puts "Group Found"
    
      # Search for Tracks
    
      end_of_group = false
      offset = 0
    
      until end_of_group do
      
        tracks = HTTParty.get("http://api.soundcloud.com/groups/#{@group["id"]}/tracks.json?consumer_key=#{Settings.key}&offset=#{offset}")
      
        puts "#{tracks.length} Tracks Found"
      
        end_of_group = true if tracks.length == 0
      
        for track in tracks
          if track["sharing"] == "public"
        
            # Find or Create User
            user = User.find_or_initialize_by_uid(track["user"]["id"])

            user.update_attributes({
              :name => "",
              :username => track["user"]["username"],
              :permalink => track["user"]["permalink"],
              :avatar_url => track["user"]["avatar_url"]
            })

            # Identify or Create Track
            track = user.tracks.identify_or_create_from_soundcloud(track)          
          end        
        end
      
        offset += 50
      
      end
    end
  end
end
