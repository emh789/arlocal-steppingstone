class Audio < ApplicationRecord


  extend FriendlyId
  extend Neighborable
  extend Paginateable
  include Seedable

  # scope :order_by_date_released_asc,  -> { order(date_released: :asc ) }
  # scope :order_by_date_released_desc, -> { order(date_released: :desc) }
  # scope :order_by_filepath_asc,       -> { order(source_file_path: :asc ) }
  # scope :order_by_filepath_desc,      -> { order(source_file_path: :desc) }
  # scope :order_by_isrc_asc,           -> { order(isrc_country_code: :asc ).order(isrc_registrant_code: :asc ).order(isrc_year_of_reference: :asc ).order(isrc_designation_code: :asc ) }
  # scope :order_by_isrc_desc,          -> { order(isrc_country_code: :desc).order(isrc_registrant_code: :desc).order(isrc_year_of_reference: :desc).order(isrc_designation_code: :desc) }
  # scope :order_by_title_asc,          -> { order(Audio.arel_table[:title].lower.asc ) }
  # scope :order_by_title_desc,         -> { order(Audio.arel_table[:title].lower.desc) }
  scope :publicly_indexable, -> { where(visibility: ['public']) }
  scope :publicly_linkable,  -> { where(visibility: ['public', 'unlisted']) }

  friendly_id :slug_candidates, use: :slugged

  before_validation :strip_whitespace_edges_from_entered_text
  before_validation :strip_any_leading_slash_from_source_imported_file_path

  validates :duration_hrs,           allow_blank: true, numericality: { only_integer: true }
  validates :duration_mins,          allow_blank: true, length: { maximum: 3 }, numericality: { only_integer: true }
  validates :duration_secs,          allow_blank: true, length: { maximum: 3 }, numericality: { only_integer: true }
  validates :duration_mils,          allow_blank: true, length: { maximum: 3 }, numericality: { only_integer: true }
  validates :isrc_country_code,      allow_blank: true, length: { is: 2 }
  validates :isrc_designation_code,  allow_blank: true, length: { is: 5 }, uniqueness: { scope: :isrc_year_of_reference }
  validates :isrc_registrant_code,   allow_blank: true, length: { is: 3 }
  validates :isrc_year_of_reference, allow_blank: true, length: { is: 2 }

  has_many :album_audio,    dependent: :destroy
  has_many :audio_keywords, dependent: :destroy
  has_many :event_audio,    dependent: :destroy

  has_many :albums,   through: :album_audio
  has_many :events,   through: :event_audio
  has_many :keywords, through: :audio_keywords

  has_one_attached :source_uploaded

  accepts_nested_attributes_for :album_audio,    allow_destroy: true
  accepts_nested_attributes_for :audio_keywords, allow_destroy: true, reject_if: proc { |attributes| attributes['keyword_id'] == '0' }
  accepts_nested_attributes_for :event_audio,    allow_destroy: true



  protected


  def self.source_type_options
    [:imported, :uploaded]
  end


  def self.source_type_options_for_select
    Audio.source_type_options.map { |option| [option, option] }
  end



  public


  ### artist


  ### audio_artist


  def album_audio_sorted
    album_audio_sorted_by_title_asc
  end


  def album_audio_sorted_by_title_asc
    album_audio.to_a.sort_by! { |aa| aa.album.title.downcase }
  end


  ### albums_count


  def albums_sorted
    albums_sorted_by_title_asc
  end


  def albums_sorted_by_title_asc
    albums.to_a.sort_by! { |album| album.title.downcase }
  end


  def audio_keywords_sorted
    audio_keywords_sorted_by_title_asc
  end


  def audio_keywords_sorted_by_title_asc
    audio_keywords.to_a.sort_by! { |ak| ak.keyword.title.downcase }
  end


  ### composer


  ### copright_markup_type


  def copyright_props
    { markup_type: copyright_markup_type, markup_text: copyright_markup_text }
  end


  ### copyright_markup_text


  ### created_at


  ### date_released


  def date_released_sortable
    date_released ? date_released : Date.new(0)
  end


  ### description_markup_type


  def description_props
    { markup_type: description_markup_type, markup_text: description_markup_text }
  end


  ### description_markup_text


  def does_have_albums
    albums_count.to_i > 0
  end


  def does_have_source_uploaded
    self.source_uploaded.attached? == true
  end


  def does_have_events
    events_count.to_i > 0
  end


  def does_have_keywords
    keywords_count.to_i > 0
  end


  def does_have_subtitle
    subtitle.to_s.length > 0
  end


  def does_not_have_source_uploaded
    self.source_uploaded.attached? == false
  end


  def duration(rounded_to: nil)
    case rounded_to
    when :mins, :minutes
      duration_rounded_to_minutes
    when :secs, :seconds
      duration_rounded_to_seconds
    when :cents
      duration_rounded_to_cents
    when :mils, :milliseconds
      duration_rounded_to_milliseconds
    else
      duration_rounded_to_milliseconds
    end
  end


  def duration_rounded_to_minutes
    mins = duration_mins.to_i
    secs = duration_secs.to_i
    if secs >= 30
      mins = mins + 1
    end
    "#{mins.to_s}"
  end


  def duration_rounded_to_seconds
    mins = duration_mins.to_i
    secs = duration_secs.to_i
    mils = duration_mils.to_i
    if mils >= 500
      secs = secs + 1
    end
    if secs >= 60
      mins = mins + 1
      secs = secs - 60
    end
    "#{mins}:#{secs.to_s.rjust(2, '0')}"
  end


  def duration_rounded_to_cents
    mins = duration_mins.to_i
    secs = duration_secs.to_i
    cents = duration_mils.to_i.fdiv(10).round
    if cents >= 100
      secs = secs + 1
      cents = cents - 100
    end
    if secs >= 60
      mins = mins + 1
      secs = secs - 60
    end
    "#{mins}:#{secs.to_s.rjust(2, '0')}.#{cents.to_s.rjust(2, '0')}"
  end


  def duration_rounded_to_milliseconds
    "#{duration_mins}:#{duration_secs.to_s.rjust(2, '0')}.#{duration_mils.to_s.rjust(3, '0')}"
  end


  ### duration_hrs


  ### duration_mins


  ### duration_secs


  ### duration_mils


  def event_audio_sorted
    event_audio_sorted_by_datetime_asc
  end


  def event_audio_sorted_by_datetime_asc
    event_audio.to_a.sort_by! { |ea| ea.event.datetime }
  end


  def events_sorted
    events_sorted_by_datetime_asc
  end


  def events_sorted_by_datetime_asc
    events.to_a.sort_by! { |event| event.datetime }
  end


  # combines and formats title, subtitle
  def full_title
    full_title = ''
    if subtitle && !subtitle.blank?
      full_title = "#{title} (#{subtitle})"
    else
      full_title = title
    end
    full_title
  end


  def has_albums
    does_have_albums
  end


  ### id


  def id_admin
    friendly_id
  end


  def id_public
    friendly_id
  end


  def indexed
    ['public'].include?(visibility)
  end


  def isrc
    [isrc_country_code, isrc_registrant_code, isrc_year_of_reference, isrc_designation_code].join
  end


  def isrc_hyphenated
    [isrc_country_code, isrc_registrant_code, isrc_year_of_reference, isrc_designation_code].join('-')
  end


  ### isrc_country_code


  ### isrc_designation_code


  ### isrc_registrant_code


  ### isrc_year_of_reference


  def joined_albums
    album_audio_sorted
  end


  def joined_events
    event_audio_sorted
  end

  def joined_keywords
    audio_keywords_sorted
  end


  ### keywords_count


  def keywords_sorted
    keywords_sorted_by_title_asc
  end


  def keywords_sorted_by_title_asc
    keywords.to_a.sort_by! { |keyword| keyword.title.downcase }
  end


  ### musicians_markup_type


  def musicians_props
    { markup_type: musicians_markup_type, markup_text: musicians_markup_text }
  end


  ### musicians_markup_text


  ### personnel_markup_type


  def personnel_props
    { markup_type: personnel_markup_type, markup_text: personnel_markup_text }
  end


  ### personnel_markup_text


  def published
    ['public','unlisted'].include?(visibility)
  end


  ### recording


  def should_generate_new_friendly_id?
    date_released_changed? ||
    source_uploaded.changed? ||
    subtitle_changed? ||
    title_changed? ||
    super
  end


  def slug_candidates
    [
      [:title],
      [:title, :subtitle],
      [:title, :subtitle, :year]
    ]
  end


  def source_file_does_exist
    case source_type
    when 'imported', 'uploaded'
      File.exist?(source_absolute_path_to_file)
    end
  end


  def source_file_does_not_exist
    case source_type
    when 'imported', 'uploaded'
      File.exist?(source_absolute_path_to_file) == false
    end
  end


  def source_file_extname
    File::extname(source_file_path.to_s)
  end


  def source_file_extension
    source_file_extname.to_s.gsub(/\A./,'')
  end


  def source_file_extension_or_dummy
    if source_file_extname.to_s == ''
      'm4a'
    else
      source_file_extension
    end
  end


  def source_file_mime_type
    Mime::Type.lookup_by_extension(source_file_extension)
  end


  def source_file_path
    case source_type
    when 'imported'
      source_imported_file_path
    when 'uploaded'
      source_uploaded_file_path
    when 'url'
      false
    else
      ''
    end
  end


  ### source_imported_file_path


  def source_is_file
    case source_type
    when 'imported'
      true
    when 'uploaded'
      true
    else
      false
    end
  end


  def source_is_url
    case source_type
    when 'url'
      true
    else
      false
    end
  end


  ### source_type


  def source_uploaded_file_path
    if source_uploaded.attached?
      source_uploaded.blob.filename.to_s
    end
  end


  ### subtitle


  def title
    if super.to_s == ''
      '(untitled)'
    else
      super
    end
  end


  def title_downcase
    title.downcase
  end


  def update_and_recount_joined_resources(audio_params)
    Audio.reset_counters(id, :albums, :keywords)
    update(audio_params)
  end


  ### updated_at


  ### visibility


  def year
    if date_released
      date_released.year
    end
  end



  private


  def source_absolute_path_to_file
    case source_type
    when 'imported'
      File.join(Rails.application.config.x.arlocal[:source_imported_filesystem_dirname], source_imported_file_path)
    when 'uploaded'
      ActiveStorage::Blob.service.send(:path_for, source_uploaded.key)
    end
  end


  def strip_any_leading_slash_from_source_imported_file_path
    if self.source_imported_file_path_changed? && self.source_imported_file_path[0] == File::SEPARATOR
      self.source_imported_file_path[0] = ''
    end
  end


  def strip_whitespace_edges_from_entered_text
    strippable_attributes = [
      'audio_artist',
      'composer',
      'copyright_markup_text',
      'description_markup_text',
      'musicians_markup_text',
      'personnel_markup_text',
      'source_imported_file_path',
      'subtitle',
      'title'
    ]
    changed_strippable_attributes = self.changed.select { |v| strippable_attributes.include?(v) }
    changed_strippable_attributes.each do |a|
      stripped_attribute = self.read_attribute(a).to_s.strip
      self.write_attribute(a, stripped_attribute)
    end
  end


end
