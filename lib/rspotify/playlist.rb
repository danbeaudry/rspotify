module RSpotify

  class Playlist < Base

    def self.find(user_id, id)
      json = RSpotify.auth_get("users/#{user_id}/playlists/#{id}")
      Playlist.new json
    end

    def self.search
      #TODO
    end

    def initialize(options = {})
      @collaborative = options['collaborative']
      @description   = options['description']
      @followers     = options['followers']
      @images        = options['images']
      @name          = options['name']
      @public        = options['public']

      @owner = if options['owner']
        User.new options['owner']
      end

      @tracks = if options['tracks'] && options['tracks']['items']
        options['tracks']['items'].map { |t| Track.new t['track'] }
      end

      super(options)
    end

    def complete!
      initialize RSpotify.auth_get("users/#{@owner.id}/playlists/#{@id}")
    end
  end
end
