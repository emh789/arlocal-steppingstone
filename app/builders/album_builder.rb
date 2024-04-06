class AlbumBuilder


  attr_reader :album


  def initialize
    @album = Album.new
  end



  protected


  def self.build
    builder = new
    yield(builder)
    builder.album
  end


  def self.build_with_defaults
    self.build do |b|
      b.assign_default_attributes
    end
  end


  def self.create(album_params)
    self.build do |b|
      b.assign_default_attributes
      b.assign_given_attributes(album_params)
    end
  end



  public


  def assign_default_attributes
    @album.assign_attributes(params_default)
  end


  def assign_given_attributes(album_params)
    @album.assign_attributes(album_params)
  end


  private


  def params_default
    {
      artist: ArlocalSettings.first.artist_name,
      album_pictures_sort_method: 'cover_manual_asc',
      copyright_markup_type: 'string',
      description_markup_type: 'plaintext',
      index_can_display_tracklist: true,
      index_tracklist_audio_includes_subtitles: true,
      musicians_markup_type: 'plaintext',
      personnel_markup_type: 'plaintext',
      show_can_cycle_pictures: true,
      visibility: 'private'
    }
  end


end
