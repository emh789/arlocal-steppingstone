class HomepageTarget

  extend InactiveRecordSingleton

  DATA = [
    {
      description: 'Album – most recent',
      id: 'album_latest',
      method: -> { QueryAlbums.select_public_most_recent }
    },
    {
      description: 'Albums – index',
      id: 'albums_index',
      method: -> { Albums }
    },
    {
      description: 'Info',
      id: 'info',
      method: -> { Infopage }
    },
    {
      description: 'Video – most recent',
      id: 'video_latest',
      method: -> { QueryVideos.select_public_most_recent }
    },
    {
      description: 'Videos – index',
      id: 'videos_index',
      method: -> { Videos }
    }
  ]


  attr_reader :id, :description, :id, :method

  def initialize(target)
    if target
      @id = target[:id]
      @description = target[:description]
      @method = target[:method]
    end
  end

end
