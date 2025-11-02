class PictureBuilder

  require 'exiftool'

  attr_reader :picture

  def initialize(**args)
    arlocal_settings = (ArlocalSettings === args[:arlocal_settings]) ? args[:arlocal_settings] : nil
    picture = (Picture === args[:picture]) ? args[:picture] : Picture.new

    @arlocal_settings = arlocal_settings
    @metadata = nil
    @picture = picture
  end


  protected

  def self.build(**args)
    builder = new(**args)
    yield(builder)
    builder.picture
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

  def self.collection_with_leading_nil(collection)
    [self.nil_picture].concat(collection.to_a)
  end

  def self.create(picture_params, **args)
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(picture_params)
    end
  end

  def self.create_from_import(picture_params, **args)
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(picture_params)
      b.source_type_assign('imported')
      b.metadata_read_from_imported_file
      b.metadata_assign
    end
  end

  def self.create_from_import_and_join_nested_album(picture_params, **args)
    self.build(**args) do |b|
      b.attributes_default_assign
      if picture_params['album_pictures_attributes']['0']['album_id'] == ''
        b.raise_album_selection_required
      end
      b.attributes_given_assign(picture_params)
      b.source_type_assign('imported')
      b.metadata_read_from_imported_file
      b.metadata_assign
    end
  end

  def self.create_from_import_and_join_nested_event(picture_params, **args)
    self.build(**args) do |b|
      if picture_params['event_pictures_attributes']['0']['event_id'] == ''
        b.raise_event_selection_required
      end
      b.attributes_default_assign
      b.attributes_given_assign(picture_params)
      b.source_type_assign('imported')
      b.metadata_read_from_imported_file
      b.metadata_assign
    end
  end

  def self.create_from_import_nested_within_album(album, params, **args)
    picture_params = {
      source_imported_file_path: params['pictures_attributes']['0']['source_imported_file_path'],
      source_type: 'imported'
    }
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(picture_params)
      b.metadata_read_from_imported_file
      b.metadata_assign
      b.join_to_album(album)
    end
  end

  def self.create_from_import_nested_within_event(event, params, **args)
    picture_params = {
      source_imported_file_path: params['pictures_attributes']['0']['source_imported_file_path'],
      source_type: 'imported'
    }
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(picture_params)
      b.metadata_read_from_imported_file
      b.metadata_assign
      b.join_to_event(event)
    end
  end

  def self.create_from_import_nested_within_keyword(keyword, params, **args)
    picture_params = {
      source_imported_file_path: params['pictures_attributes']['0']['source_imported_file_path'],
      source_type: 'imported'
    }
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(picture_params)
      b.metadata_read_from_imported_file
      b.metadata_assign
      b.join_to_keyword(keyword)
    end
  end

  def self.create_from_import_nested_within_video(video, params, **args)
    picture_params = {
      source_imported_file_path: params['pictures_attributes']['0']['source_imported_file_path'],
      source_type: 'imported'
    }
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(picture_params)
      b.metadata_read_from_imported_file
      b.metadata_assign
      b.join_to_video(video)
    end
  end

  def self.create_from_upload(params, **args)
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(params)
      b.source_type_assign('uploaded')
      b.metadata_read_from_uploaded
      b.metadata_assign
    end
  end

  def self.create_from_upload_and_join_nested_album(picture_params, **args)
    self.build(**args) do |b|
      b.attributes_default_assign
      if picture_params['album_pictures_attributes']['0']['album_id'] == ''
        b.raise_album_selection_required
      end
      b.attributes_given_assign(picture_params)
      b.source_type_assign('uploaded')
      b.metadata_read_from_uploaded
      b.metadata_assign
    end
  end

  def self.create_from_upload_and_join_nested_event(picture_params, **args)
    self.build(**args) do |b|
      b.attributes_default_assign
      if picture_params['event_pictures_attributes']['0']['event_id'] == ''
        b.raise_event_selection_required
      end
      b.attributes_given_assign(picture_params)
      b.source_type_assign('uploaded')
      b.metadata_read_from_uploaded
      b.metadata_assign
    end
  end

  def self.create_from_upload_nested_within_album(album, params, **args)
    picture_params = {
      source_uploaded: params['pictures_attributes']['0']['source_uploaded'],
      source_type: 'uploaded'
    }
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(picture_params)
      b.metadata_read_from_uploaded
      b.metadata_assign
      b.join_to_album(album)
    end
  end

  def self.create_from_upload_nested_within_event(event, params, **args)
    picture_params = {
      source_uploaded: params['pictures_attributes']['0']['source_uploaded'],
      source_type: 'uploaded'
    }
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(params)
      b.metadata_read_from_uploaded
      b.metadata_assign
      b.join_to_event(event)
    end
  end

  def self.create_from_upload_nested_within_keyword(keyword, params, **args)
    picture_params = {
      source_uploaded: params['pictures_attributes']['0']['source_uploaded'],
      source_type: 'uploaded'
    }
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(picture_params)
      b.metadata_read_from_uploaded
      b.metadata_assign
      b.join_to_keyword(keyword)
    end
  end

  def self.create_from_upload_nested_within_video(video, params, **args)
    picture_params = {
      source_uploaded: params['pictures_attributes']['0']['source_uploaded'],
      source_type: 'uploaded'
    }
    self.build(**args) do |b|
      b.attributes_default_assign
      b.attributes_given_assign(picture_params)
      b.metadata_read_from_uploaded
      b.metadata_assign
      b.join_to_video(video)
    end
  end

  def self.nil_picture
    Picture.new(
      id: nil,
      title_without_markup: ' '
    )
  end


  public

  def attributes_default_assign
    @picture.assign_attributes(params_default)
  end

  def attributes_given_assign(picture_params)
    @picture.assign_attributes(picture_params)
  end

  def conditionally_build_autokeyword
    if @arlocal_settings.admin_forms_new_will_have_autokeyword && @picture.picture_keywords.empty?
      @picture.picture_keywords.build(keyword_id: @arlocal_settings.admin_forms_autokeyword_id)
    end
  end

  def join_to_album(album)
    album_id = album.id
    @picture.album_pictures.build(album_id: album_id)
  end

  def join_to_event(event)
    event_id = event.id
    @picture.event_pictures.build(event_id: event_id)
  end

  def join_to_keyword(keyword)
    keyword_id = keyword.id
    @picture.album_pictures.build(keyword_id: keyword_id)
  end

  def join_to_video(video)
    video_id = video.id
    @picture.video_pictures.build(video_id: video_id)
  end

  def metadata_assign
    if metadata_is_assigned
      @picture.datetime_from_exif = determine_time_from_exif_formatting(@metadata.raw[:date_time_original])
      @picture.datetime_from_file = determine_time_from_exif_formatting(@metadata.raw[:file_modify_date])
      @picture.title_markup_text = @picture.source_file_basename
    end
  end

  def metadata_is_assigned
    Exiftool === @metadata
  end

  def metadata_is_not_assigned
    metadata_is_assigned == false
  end

  def metadata_read_from_imported_file
    if @picture.source_imported_file_exists
      @metadata = Exiftool.new(source_imported_full_path)
    else
      @picture.errors.add(:source_file, :not_found, message: 'Source file not found.')
    end
  end

  def metadata_read_from_uploaded
    if @picture.source_uploaded_file_exists
      @picture.source_uploaded.open do |i|
        @metadata = Exiftool.new(i.path)
      end
    else
      @picture.errors.add(:source_file, :file_not_uploaded, message: 'Source file is required.')
    end
  end

  def raise_album_selection_required
    @picture.errors.add(:album, :album, message: 'Album is required.')
  end

  def raise_event_selection_required
    @picture.errors.add(:event, :event, message: 'Event is required.')
  end

  def source_type_assign(source_type)
    @picture.source_type = source_type
  end


  private

  def determine_time_from_exif_formatting(time_string_exif)
    if time_string_exif
      time_match_data = /(\d+):(\d+):(\d+)\s(\d+):(\d+):(\d+)(-?\d*:?\d*)/.match(time_string_exif)
      if time_match_data[7].to_s == ''
        time_array = time_match_data[1..6]
      else
        time_array = time_match_data[1..7]
      end
      Time.new(*time_array)
    end
  end

  def params_default
    {
      credits_markup_type: 'plaintext',
      datetime_from_manual_entry_zone: Rails.application.config.time_zone,
      description_markup_type: 'plaintext',
      show_can_display_title: true,
      title_markup_type: 'string',
      visibility: 'admin_only'
    }
  end

end
