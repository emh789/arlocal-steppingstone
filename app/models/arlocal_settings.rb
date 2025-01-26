class ArlocalSettings < ApplicationRecord

  has_one_attached :icon_image

  before_validation :strip_whitespace_edges_from_entered_text
  before_validation :strip_any_leading_slash_from_icon_source_imported_file_path

  validates :admin_forms_autokeyword_id, presence: true, if: :admin_forms_autokeyword_enabled


  protected

  def self.icon_source_type_options
    [:imported, :uploaded]
  end

  def self.icon_source_type_options_for_select
    ArlocalSettings.icon_source_type_options.map{ |option| [option, option] }
  end


  public

  ### admin_forms_autokeyword_enabled

  ### admin_forms_autokeyword_id

  ### admin_forms_edit_slug_field

  def admin_forms_new_will_have_autokeyword
    (admin_forms_autokeyword_enabled) && (admin_forms_autokeyword_id.to_i != 0)
  end

  ### admin_forms_retain_pane_for_neighbors

  ### admin_forms_selectable_pictures_sort_method

  ### admin_index_albums_sort_method

  ### admin_index_audio_sort_method

  ### admin_index_events_sort_method

  ### admin_index_isrc_sort_method

  ### admin_index_pictures_sort_method

  ### admin_index_videos_sort_method

  ### artist_content_copyright_year_earliest

  ### artist_content_copyright_year_latest

  ### artist_name

  def artist_name_downcase
    artist_name.to_s.downcase
  end

  def artist_name_capitalized
    names = artist_name.to_s.split(' ')
    names.map{ |name| name.capitalize }.join(' ')
  end

  ### audio_default_date_released

  ### audio_default_date_released_enabled

  ### audio_default_isrc_country_code

  ### audio_default_iscr_registrant_code

  ### created_at

  def does_have_source_uploaded(attribute)
    case attribute
    when :icon_image
      self.icon_image.attached? == true
    end
  end

  def does_not_have_source_uploaded(attribute)
    case attribute
    when :icon_image
      self.icon_image.attached? == false
    end
  end

  ### html_head_public_can_include_meta_description

  def html_head_public_should_include_google_analytics
    if (html_head_public_can_include_google_analytics) && (html_head_google_analytics_id.to_s != '')
      true
    end
  end

  def icon_filename
    icon_source_file_path
  end

  def icon_source_uploaded_file_path
    if icon_image.attached?
      icon_image.blob.filename.to_s
    else
      ''
    end
  end

  ### icon_source_imported_file_path

  def icon_source_file_basename
    if icon_source_file_path
      File.basename(icon_source_file_path, '.*')
    end
  end

  def icon_source_file_extname
    File::extname(icon_source_file_path.to_s)
  end

  def icon_source_file_extension
    icon_source_file_extname.to_s.gsub(/\A./,'')
  end

  def icon_source_file_mime_type
    Mime::Type.lookup_by_extension(icon_source_file_extension)
  end

  def icon_source_file_path
    case icon_source_type
    when 'attachment'
      icon_source_uploaded_file_path
    when 'imported'
      icon_source_imported_file_path
    end
  end

  def icon_source_is_file
    case source_type
    when 'attachment'
      true
    when 'imported'
      true
    else
      false
    end
  end

  ### icon_source_type

  ### id

  ### marquee_enabled

  ### marquee_markup_type

  ### marquee_markup_text

  def marquee_props
    { markup_type: marquee_markup_type, markup_text: marquee_markup_text }
  end

  def marquee_will_render
    (marquee_enabled) && (marquee_markup_text.to_s != '')
  end

  ### public_index_albums_sort_method

  ### public_index_audio_sort_method

  ### public_index_events_sort_method

  ### public_index_pictures_sort_method

  ### public_index_videos_sort_method

  def public_layout_will_have_nav
    public_nav_includeables.include?(true) == true
  end

  def public_layout_will_not_have_nav
    public_nav_includeables.include?(true) == false
  end

  ### public_nav_can_include_albums

  ### public_nav_can_include_audio

  ### public_nav_can_include_events

  ### public_nav_can_include_info

  ### public_nav_can_include_pictures

  ### public_nav_can_include_stream

  ### public_nav_can_include_videos

  def public_nav_includeables
    [
      public_nav_can_include_albums,
      public_nav_can_include_audio,
      public_nav_can_include_events,
      public_nav_can_include_info,
      public_nav_can_include_pictures,
      public_nav_can_include_stream,
      public_nav_can_include_videos
    ]
  end

  def title
    'A&R.local Settings'
  end


  private

  def strip_any_leading_slash_from_icon_source_imported_file_path
    if self.icon_source_imported_file_path_changed? && self.icon_source_imported_file_path[0] == File::SEPARATOR
      self.icon_source_imported_file_path[0] = ''
    end
  end

  def strip_whitespace_edges_from_entered_text
    strippable_attributes = [
      'artist_name',
      'icon_source_imported_file_path',
      'marquee_markup_text'
    ]
    changed_strippable_attributes = self.changed.select { |v| strippable_attributes.include?(v) }
    changed_strippable_attributes.each do |attribute|
      stripped_value = self.read_attribute(attribute).to_s.strip
      self.write_attribute(attribute, stripped_value)
    end
  end

end
