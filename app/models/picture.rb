class Picture < ApplicationRecord


  extend FriendlyId
  extend MarkupParserUtils
  extend Neighborable
  extend Paginateable
  include Seedable

  scope :publicly_indexable, -> { where(visibility: ['public']) }
  scope :publicly_linkable,  -> { where(visibility: ['public', 'unlisted']) }

  friendly_id :slug_candidates, use: :slugged

  before_validation :strip_whitespace_edges_from_entered_text
  before_validation :strip_any_leading_slash_from_source_imported_file_path

  validates :credits_parser_id,                 presence: true
  validates :datetime_from_manual_entry_year,   allow_blank: true, numericality: { only_integer: true }
  validates :datetime_from_manual_entry_month,  allow_blank: true, length: { maximum: 2 }, numericality: { only_integer: true }
  validates :datetime_from_manual_entry_day,    allow_blank: true, length: { maximum: 2 }, numericality: { only_integer: true }
  validates :datetime_from_manual_entry_hour,   allow_blank: true, length: { maximum: 2 }, numericality: { only_integer: true }
  validates :datetime_from_manual_entry_minute, allow_blank: true, length: { maximum: 2 }, numericality: { only_integer: true }
  validates :datetime_from_manual_entry_second, allow_blank: true, length: { maximum: 2 }, numericality: { only_integer: true }
  validates :description_parser_id,             presence: true
  validates :title_parser_id,                   presence: true

  validate :datetime_is_valid?

  before_save :create_attr_title_without_markup

  has_many :album_pictures,   dependent: :destroy
  has_many :event_pictures,   dependent: :destroy
  has_many :picture_keywords, dependent: :destroy
  has_many :video_pictures,   dependent: :destroy

  has_many :albums,   through: :album_pictures
  has_many :events,   through: :event_pictures
  has_many :keywords, through: :picture_keywords
  has_many :videos,   through: :video_pictures

  has_many :infopage_items, -> { where infopageable_type: 'Picture' }, foreign_key: :infopageable_id, dependent: :destroy
  has_many :infopages, through: :infopage_items

  has_one_attached :source_uploaded

  accepts_nested_attributes_for :album_pictures,    allow_destroy: true
  accepts_nested_attributes_for :event_pictures,    allow_destroy: true
  accepts_nested_attributes_for :picture_keywords,  allow_destroy: true, reject_if: proc { |attributes| attributes['keyword_id'] == '0' }
  accepts_nested_attributes_for :video_pictures,    allow_destroy: true


  protected


  def self.source_type_options
    [:imported, :uploaded]
  end


  def self.source_type_options_for_select
    Picture.source_type_options.map{ |option| [option, option] }
  end


  public


  ### albums_count


  def album_pictures_sorted
    album_pictures_sorted_by_title_asc
  end


  def album_pictures_sorted_by_title_asc
    album_pictures.to_a.sort_by! { |ap| ap.album.title.downcase }
  end


  def albums_sorted
    albums_sorted_by_title_asc
  end


  def albums_sorted_by_title_asc
    albums.to_a.sort_by! { |album| album.title.downcase }
  end


  ### created_at


  ### credits_parser_id


  def credits_props
    { parser_id: credits_parser_id, text_markup: credits_text_markup }
  end


  ### credits_text_markup


  def datetime
    datetime_effective_value
  end


  ### datetime_cascade_method


  ### datetime_cascade_value


  def datetime_effective_method
    if datetime_from_manual_entry.to_s != ''
      'manual entry'
    elsif datetime_from_exif.to_s != ''
      'picture EXIF data'
    elsif datetime_from_file.to_s != ''
      'file date/time'
    else
      'unknown'
    end
  end


  def datetime_effective_value
    case datetime_effective_method
    when 'manual entry'
      datetime_from_manual_entry
    when 'picture EXIF data'
      datetime_from_exif
    when 'file date/time'
      datetime_from_file
    when 'unknown'
      Time.new(0)
    end
  end



  def datetime_from_manual_entry
    if datetime_from_manual_entry_array_to_best_precision.any?
      DateTime.new(*datetime_from_manual_entry_array_to_best_precision).strftime('%Y-%m-%d %H:%M:%S')
    end
  end


  def datetime_from_manual_entry_array
    h = datetime_from_manual_entry_hash
    [
      h[:year],
      h[:month],
      h[:day],
      h[:hour],
      h[:minute],
      h[:second]
    ]
  end


  def datetime_from_manual_entry_array_to_best_precision
    a = datetime_from_manual_entry_array
    a[0...a.find_index(nil)]
  end


  def datetime_from_manual_entry_hash
    h = {
      year: datetime_from_manual_entry_year,
      month: datetime_from_manual_entry_month,
      day: datetime_from_manual_entry_day,
      hour: datetime_from_manual_entry_hour,
      minute: datetime_from_manual_entry_minute,
      second: datetime_from_manual_entry_second
    }
    h.delete_if { |k,v| v.to_s == "" }
  end


  ### datetime_from_manual_entry_year


  ### datetime_from_manual_entry_month


  ### datetime_from_manual_entry_day


  ### datetime_from_manual_entry_hour


  ### datetime_from_manual_entry_minute


  ### datetime_from_manual_entry_second


  ### datetime_from_exif


  ### datetime_from_file


  def datetime_year
    case datetime
    when String
      Date.parse(datetime).year
    when Time
      datetime.year
    end
  end


  ### description_parser_id


  def description_props
    { parser_id: description_parser_id, text_markup: description_text_markup }
  end


  ### description_text_markup


  ### events_count


  def does_have_albums
    albums_count.to_i > 0
  end


  def does_have_credits
    credits_text_markup.to_s != ''
  end


  def does_have_datetime
    datetime != Time.new(0)
  end


  def does_have_description
    description_text_markup != ''
  end


  def does_have_events
    events_count.to_i > 0
  end


  def does_have_keywords
    keywords_count.to_i > 0
  end


  def does_have_source_uploaded
    self.source_uploaded.attached? == true
  end


  def does_have_title
    title_text_markup.to_s != ''
  end


  def does_have_videos
    videos_count.to_i > 0
  end


  def does_not_have_slug
    (slug == nil) || (slug.to_s == '')
  end


  def does_not_have_source_uploaded
    self.source_uploaded.attached? == false
  end


  def does_not_have_title
    (title == nil) || (title.to_s == '')
  end


  def event_pictures_sorted
    event_pictures_sorted_by_title_asc
  end


  def event_pictures_sorted_by_title_asc
    event_pictures.to_a.sort_by! { |ep| ep.event.title.downcase }
  end


  def events_sorted
    events_sorted_by_title_asc
  end


  def events_sorted_by_title_asc
    events.to_a.sort_by! { |event| event.title.downcase }
  end


  def filename
    source_file_path
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


  def joined_albums
    album_pictures_sorted
  end


  def joined_events
    event_pictures_sorted
  end


  def joined_keywords
    picture_keywords_sorted
  end


  def joined_videos
    video_pictures_sorted
  end


  ### keywords_count


  def keywords_sorted
    keywords_sorted_by_title_asc
  end


  def keywords_sorted_by_title_asc
    keywords.to_a.sort_by! { |keyword| keyword.title }
  end


  ### picture_keywords


  def picture_keywords_sorted
    picture_keywords_sorted_by_title_asc
  end


  def picture_keywords_sorted_by_title_asc
    picture_keywords.to_a.sort_by! { |pk| pk.keyword.title.downcase }
  end


  def published
    ['public','unlisted'].include?(visibility)
  end


  def should_generate_new_friendly_id?
    datetime_from_exif_changed? ||
    datetime_from_file_changed? ||
    datetime_from_manual_entry_year_changed? ||
    datetime_from_manual_entry_month_changed? ||
    datetime_from_manual_entry_day_changed? ||
    datetime_from_manual_entry_hour_changed? ||
    datetime_from_manual_entry_minute_changed? ||
    datetime_from_manual_entry_second_changed? ||
    source_uploaded.changed? ||
    source_imported_file_path_changed? ||
    source_type_changed? ||
    super
  end


  ### show_can_display_title


  def show_will_display_title
    show_can_display_title && does_have_title
  end


  ### slug


  def slug_candidates
    [
      [:source_file_basename],
      [:source_file_basename, :datetime ]
    ]
  end


  def source_file_basename
    if source_file_path
      File.basename(source_file_path, '.*')
    end
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
      source_url
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
    else
      ''
    end
  end


  def title
    title_without_markup
  end


  def title_for_select
    if title_without_markup.to_s == ''
      '(untitled)'
    else
      title_without_markup
    end
  end


  ### title_parser_id


  def title_props
    { parser_id: title_parser_id, text_markup: title_text_markup }
  end


  ### title_text_markup


  ### title_without_markup


  def title_without_markup_downcase
    title_without_markup.downcase
  end


  def update_and_recount_joined_resources(picture_params)
    Picture.reset_counters(id, :albums, :events, :keywords, :videos)
    update(picture_params)
  end


  ### updated_at


  def video_pictures_sorted
    video_pictures_sorted_by_title_asc
  end


  def video_pictures_sorted_by_title_asc
    video_pictures.to_a.sort_by! { |vp| vp.video.title.downcase }
  end


  def videos_sorted
    videos_sorted_by_title_asc
  end


  def videos_sorted_by_title_asc
    videos.to_a.sort_by! { |video| video.title.downcase }
  end


  ### visibility



  private


  def create_attr_title_without_markup
    self.title_without_markup = ApplicationController.helpers.parser_remove_markup(self.title_props).strip.to_s
  end


  def datetime_is_valid?
    begin
      if datetime_from_manual_entry_array_to_best_precision.any?
        DateTime === DateTime.new(*self.datetime_from_manual_entry_array_to_best_precision)
      end
    rescue Date::Error
      self.errors.add :base, :invalid_date, message: 'Invalid date.'
    end
  end


  def source_absolute_path_to_file
    case source_type
    when 'uploaded'
      ActiveStorage::Blob.service.send(:path_for, source_uploaded.key)
    when 'imported'
      File.join(Rails.application.config.x.arlocal[:source_imported_filesystem_dirname], source_imported_file_path)
    end
  end


  def strip_any_leading_slash_from_source_imported_file_path
    if self.source_imported_file_path[0] == '/'
      self.source_imported_file_path[0] = ''
    end
  end


  def strip_whitespace_edges_from_entered_text
    [ self.credits_text_markup,
      self.description_text_markup,
      self.source_imported_file_path,
      self.title_text_markup,
    ].each { |a| a.to_s.strip! }
  end



end
