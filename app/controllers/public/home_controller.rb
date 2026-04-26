class Public::HomeController < PublicController

  def show
    homepage_target = HomepageTarget.find(@arlocal_settings.public_homepage_target)
    redirect_to homepage_target.method.call, status: :found
  end

  def album_url(album)
    public_album_url(album.id_public)
  end

  def albums_url
    public_albums_url
  end

  def infopages_url
    public_infopage_first_path
  end

  def video_url(video)
    public_video_url(video.id_public)
  end

  def videos_path
    public_videos_url
  end

end
