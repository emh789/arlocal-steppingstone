class SorterAlbumPictures
  extend InactiveRecordSingleton


  DATA = [
    {
      id: 'cover_datetime_asc',
      description: 'coverpicture first, then date/time cascade (old - new)',
      method: lambda { |album_pictures| SorterAlbumPictures.cover_datetime_asc(album_pictures) },
    },
    {
      id: 'cover_datetime_desc',
      description: 'coverpicture first, then date/time cascade (new - old)',
      method: lambda { |album_pictures| SorterAlbumPictures.cover_datetime_desc(album_pictures) },
    },
    {
      id: 'cover_manual_asc',
      description: 'coverpicture first, then manual order (low - high)',
      method: lambda { |album_pictures| SorterAlbumPictures.cover_manual_asc(album_pictures) },
    },
    {
      id: 'cover_manual_desc',
      description: 'coverpicture first, then manual order (high - low)',
      method: lambda { |album_pictures| SorterAlbumPictures.cover_manual_desc(album_pictures) },
    }
  ]


  attr_reader :id, :description, :method


  def initialize(sorter)
    if sorter
      @id = sorter[:id]
      @description = sorter[:description]
      @method = sorter[:method]
    end
  end



  public


  def call(album_pictures)
    @method.call(album_pictures)
  end


  def sort(album_pictures)
    call(album_pictures)
  end



  protected


  def self.cover_datetime_asc(album_pictures)
    album_pictures.order('album_pictures.is_coverpicture DESC').joins(:picture).order('pictures.datetime_cascade_value ASC')
  end


  def self.cover_datetime_desc(album_pictures)
    album_pictures.order('album_pictures.is_coverpicture DESC').joins(:picture).order('pictures.datetime_cascade_value DESC')
  end


  def self.cover_manual_asc(album_pictures)
    album_pictures.order('album_pictures.is_coverpicture DESC').order('album_pictures.album_order ASC')
  end


  def self.cover_manual_desc(album_pictures)
    album_pictures.order('album_pictures.is_coverpicture DESC').order('album_pictures.album_order DESC')
  end


end
