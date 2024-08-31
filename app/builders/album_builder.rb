class AlbumBuilder

  attr_reader :album

  def initialize(**args)
    arlocal_settings = (ArlocalSettings === args[:arlocal_settings]) ? args[:arlocal_settings] : nil
    album = (Album === args[:album]) ? args[:album] : Album.new

    @arlocal_settings = arlocal_settings
    @album = album
  end


  protected

  def self.build(**args)
    builder = new(**args)
    yield(builder)
    builder.album
  end

  def self.build_with_defaults(**args)
    self.build(**args) do |b|
      b.assign_default_attributes
    end
  end

  def self.build_with_defaults_and_conditional_autokeyword(**args)
    self.build(**args) do |b|
      b.assign_default_attributes
      b.conditionally_build_autokeyword
    end
  end

  def self.create(album_params, **args)
    self.build(**args) do |b|
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

  def conditionally_build_autokeyword
    if @arlocal_settings.admin_forms_new_will_have_autokeyword
      @album.album_keywords.build(keyword_id: @arlocal_settings.admin_forms_autokeyword_id)
    end
  end


  private

  def params_default
    {
      artist: params_default_artist,
      album_pictures_sort_method: 'cover_manual_asc',
      copyright_markup_type: 'string',
      description_markup_type: 'plaintext',
      index_can_display_tracklist: true,
      index_tracklist_audio_includes_subtitles: true,
      musicians_markup_type: 'plaintext',
      personnel_markup_type: 'plaintext',
      show_can_cycle_pictures: true,
      visibility: 'admin_only'
    }
  end

  def params_default_artist
    if @arlocal_settings
      @arlocal_settings.artist_name
    end
  end


end
