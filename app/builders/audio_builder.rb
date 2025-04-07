class AudioBuilder

  require 'mediainfo'

  attr_reader :audio, :metadata

  def initialize(**args)
    arlocal_settings = (ArlocalSettings === args[:arlocal_settings]) ? args[:arlocal_settings] : nil
    audio = (Audio === args[:audio]) ? args[:audio] : Audio.new

    @arlocal_settings = arlocal_settings
    @audio = audio
    @metadata = nil
  end


  protected

  def self.build(**args)
    builder = new(**args)
    yield(builder)
    builder.audio
  end

  def self.build_with_defaults(**args)
    self.build(**args) do |b|
      b.attributes_default_assign
    end
  end

  def self.build_with_defaults_and_conditional_autokeyword(**args)
    self.build(**args) do |b|
      b.attributes_default_assign
      b.conditionally_build_autokeyword
    end
  end

  def self.create(audio_params, **args)
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(audio_params)
    end
  end

  def self.create_from_import(audio_params, **args)
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(audio_params)
      b.source_type_assign('imported')
      b.metadata_read_from_imported_file
      b.metadata_assign
    end
  end

  def self.create_from_import_and_join_nested_album(audio_params, **args)
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(audio_params)
      b.source_type_assign('imported')
      b.metadata_read_from_imported_file
      b.metadata_assign
      b.set_new_album_order
    end
  end

  def self.create_from_import_and_join_nested_event(audio_params, **args)
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(audio_params)
      b.source_type_assign('imported')
      b.metadata_read_from_imported_file
      b.metadata_assign
      b.set_new_event_order
    end
  end

  def self.create_from_import_nested_within_album(album, params, **args)
    audio_params = {
      source_imported_file_path: params['audio_attributes']['0']['source_imported_file_path'],
      source_type: 'imported'
    }
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(audio_params)
      b.metadata_read_from_imported_file
      b.metadata_assign
      b.join_to_album(album)
    end
  end

  def self.create_from_import_nested_within_event(event, params, **args)
    audio_params = {
      source_imported_file_path: params['audio_attributes']['0']['source_imported_file_path'],
      source_type: 'imported'
    }
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(audio_params)
      b.metadata_read_from_imported_file
      b.metadata_assign
      b.join_to_event(event)
    end
  end

  def self.create_from_import_nested_within_keyword(keyword, params, **args)
    audio_params = {
      source_imported_file_path: params['audio_attributes']['0']['source_imported_file_path'],
      source_type: 'imported'
    }
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(audio_params)
      b.metadata_read_from_imported_file
      b.metadata_assign
      b.join_to_keyword(keyword)
    end
  end

  def self.create_from_upload(audio_params, **args)
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(audio_params)
      b.source_type_assign('uploaded')
      # b.metadata_read_from_tempfile(audio_params)
      b.metadata_read_from_uploaded
      b.metadata_assign
    end
  end

  def self.create_from_upload_and_join_nested_album(audio_params, **args)
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(audio_params)
      b.source_type_assign('uploaded')
      # b.metadata_read_from_tempfile(audio_params)
      b.metadata_read_from_uploaded
      b.metadata_assign
      b.set_new_album_order
    end
  end

  def self.create_from_upload_and_join_nested_event(audio_params, **args)
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(audio_params)
      b.source_type_assign('uploaded')
      # b.metadata_read_from_tempfile(audio_params)
      b.metadata_read_from_uploaded
      b.metadata_assign
      b.set_new_event_order
    end
  end

  def self.create_from_upload_nested_within_album(album, params, **args)
    audio_params = {
      source_uploaded: params['audio_attributes']['0']['source_uploaded'],
      source_type: 'uploaded'
    }
    self.build do |b|
      b.attributes_default_assign
      b.attributes_given_assign(audio_params)
      b.metadata_read_from_uploaded
      b.metadata_assign
      b.join_to_album(album)
    end
  end

  def self.create_from_upload_nested_within_event(event, params, **args)
    audio_params = {
      source_uploaded: params['audio_attributes']['0']['source_uploaded'],
      source_type: 'uploaded'
    }
    self.build do |b|
      b.attributes_default_assign
      b.attributes_given_assign(audio_params)
      b.metadata_read_from_uploaded
      b.metadata_assign
      b.join_to_event(event)
    end
  end

  def self.create_from_upload_nested_within_keyword(keyword, params, **args)
    audio_params = {
      source_uploaded: params['audio_attributes']['0']['source_uploaded'],
      source_type: 'uploaded'
    }
    self.build do |b|
      b.attributes_default_assign
      b.attributes_given_assign(audio_params)
      b.metadata_read_from_uploaded
      b.metadata_assign
      b.join_to_keyword(keyword)
    end
  end

  def self.refresh_id3(audio_params)
    audio = Audio.find(audio_params['id'])
    self.build(audio: audio) do |b|
      b.metadata_read
      b.metadata_assign
    end
  end


  public

  def attributes_default_assign
    @audio.assign_attributes(params_default)
  end

  def attributes_given_assign(audio_params)
    @audio.assign_attributes(audio_params)
  end

  def conditionally_build_autokeyword
    if @arlocal_settings.admin_forms_new_will_have_autokeyword
      @audio.audio_keywords.build(keyword_id: @arlocal_settings.admin_forms_autokeyword_id)
    end
  end

  def join_to_album(album)
    album_id = album.id
    album_order = @metadata.general.track_position
    @audio.album_audio.build(album_id: album_id, album_order: album_order)
  end

  def join_to_event(event)
    event_id = event.id
    event_order = @metadata.general.track_position
    @audio.event_audio.build(event_id: event_id, event_order: event_order)
  end

  def join_to_keyword(keyword)
    keyword_id = keyword.id
    @audio.audio_keyword.build(keyword_id: keyword_id)
  end

  def metadata_assign
    @audio.audio_artist = "#{@metadata.general.performer}"
    @audio.copyright_markup_text = "© #{@metadata.general.recorded_date}"
    @audio.title = @metadata.general.track ? "#{@metadata.general.track}" : "#{File.basename(@audio.source_file_path, '.*')}"
    @audio.duration_mins = @metadata.general.duration.divmod(1000)[0].divmod(60)[0]
    @audio.duration_secs = @metadata.general.duration.divmod(1000)[0].divmod(60)[1]
    @audio.duration_mils = @metadata.general.duration.divmod(1000)[1]
  end

  def metadata_is_assigned
    MediaInfo::Tracks === @metadata
  end

  def metadata_is_not_assigned
    metadata_is_assigned == false
  end

  def metadata_read
    case @audio.source_type
    when 'imported'
      metadata_read_from_imported
    when 'tempfile'
      metadata_read_from_tempfile
    when 'uploaded'
      metadata_read_from_uploaded
    end
  end

  def metadata_read_from_uploaded
    if @audio.source_uploaded.attached?
      @audio.source_uploaded.open do |a|
        @metadata = MediaInfo.from(a.path)
      end
    end
  end

  def metadata_read_from_imported_file
    if File.exist?(source_imported_full_path)
      @metadata = MediaInfo.from(source_imported_full_path)
    end
  end

  def set_new_album_order
    @audio.album_audio.first.album_order = @metadata.general.track_position
  end

  def set_new_event_order
    @audio.event_audio.first.event_order = @metadata.general.track_position
  end

  def source_type_assign(source_type)
    @audio.source_type = source_type
  end

  def update_joined_albums_order
    if @audio.does_have_albums
      album = Album.find_by_title(@metadata.general.album)
      if album
        @audio.album_audio.where(album_id: album.id).each do |aa|
          aa.album_order = @metadata.general.track_position
          aa.save
        end
      end
    end
  end

  def update_joined_events_order
    if @audio.does_have_events
      event = Event.find_by_title(@metadata.general.album)
      if event
        @audio.event_audio.where(event_id: event.id).each do |ea|
          ea.event_order = @metadata.general.track_position
          ea.save
        end
      end
    end
  end

  def update_joined_resources_order
    update_joined_albums_order
    update_joined_events_order
  end


  private

  def params_default
    {
      artist: params_default_artist,
      copyright_markup_type: 'string',
      description_markup_type: 'plaintext',
      date_released: params_default_date_released,
      isrc_country_code: params_default_isrc_country_code,
      isrc_registrant_code: params_default_isrc_registrant_code,
      musicians_markup_type: 'string',
      personnel_markup_type: 'string',
      visibility: 'admin_only'
    }
  end

  def params_default_artist
    if @arlocal_settings
      @arlocal_settings.artist_name
    end
  end

  def params_default_date_released
    if params_default_date_released_enabled
      @arlocal_settings.audio_default_date_released
    else
      Date.new(0)
    end
  end

  def params_default_date_released_enabled
    @arlocal_settings && @arlocal_settings.audio_default_date_released_enabled
  end

  def params_default_isrc_country_code
    if @arlocal_settings
      @arlocal_settings.audio_default_isrc_country_code
    end
  end

  def params_default_isrc_registrant_code
    if @arlocal_settings
      @arlocal_settings.audio_default_isrc_registrant_code
    end
  end

  def source_imported_full_path
    File.join(
      Rails.application.config.x.arlocal[:source_imported_filesystem_dirname],
      @audio.source_imported_file_path
    )
  end

end
