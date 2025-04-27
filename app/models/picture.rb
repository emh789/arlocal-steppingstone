class Picture < ApplicationRecord

  extend FriendlyId
  extend Neighborable
  extend Paginateable

  # scope :published,                   -> { any_public_released_joinable }
  scope :published,                   -> { all_public_joinable }

  scope :all_public_indexable,  -> { where(visibility: ['public_indexable']) }
  scope :all_public_joinable,   -> { where(visibility: ['public_indexable', 'public_joinable']) }
  scope :all_public_showable,   -> { where(visibility: ['public_indexable', 'public_joinable', 'public_showable']) }

  # scope :any_public_released_indexable,   -> { released.all_public_indexable }
  # scope :any_public_released_joinable,    -> { released.all_public_joinable }
  # scope :any_public_released_or_showable, -> { (Picture.any_public_released_joinable).or(Picture.only_public_showable) }

  scope :any_with_keyword, ->(keyword) { joins(:keyword).where(keywords: keyword) }

  scope :only_public_indexable, -> { where(visibility: 'public_indexable') }
  scope :only_public_joinable,  -> { where(visibility: 'public_joinable') }
  scope :only_public_showable,  -> { where(visibility: 'public_showable') }
  scope :only_admin_only,       -> { where(visibility: 'admin_only') }

  scope :include_everything,  -> { includes_albums.includes_events.includes_keywords.includes_videos.with_attachments }
  scope :includes_albums,     -> { includes(:albums) }
  scope :includes_events,     -> { includes(:events) }
  scope :includes_keywords,   -> { includes(:keywords) }
  scope :includes_videos,     -> { includes(:videos) }
  scope :with_attachments,    -> { with_attached_source_uploaded }

  friendly_id :slug_candidates, use: :slugged

  before_validation :strip_whitespace_edges_from_entered_text
  before_validation :strip_any_leading_slash_from_source_imported_file_path

  validates :credits_markup_type,               presence: true
  validates :datetime_from_manual_entry_year,   allow_blank: true, numericality: { only_integer: true }
  validates :datetime_from_manual_entry_month,  allow_blank: true, length: { maximum: 2 }, numericality: { only_integer: true }
  validates :datetime_from_manual_entry_day,    allow_blank: true, length: { maximum: 2 }, numericality: { only_integer: true }
  validates :datetime_from_manual_entry_hour,   allow_blank: true, length: { maximum: 2 }, numericality: { only_integer: true }
  validates :datetime_from_manual_entry_minute, allow_blank: true, length: { maximum: 2 }, numericality: { only_integer: true }
  validates :datetime_from_manual_entry_second, allow_blank: true, length: { maximum: 2 }, numericality: { only_integer: true }
  validates :description_markup_type,           presence: true
  validates :title_markup_type,                 presence: true

  # validate :datetime_is_valid?

  before_save :create_attr_title_without_markup

  has_many :album_pictures,   -> { includes_picture },  dependent: :destroy
  has_many :event_pictures,   -> { includes_event },    dependent: :destroy
  has_many :picture_keywords, -> { includes_keyword },  dependent: :destroy
  has_many :video_pictures,   -> { includes_video },    dependent: :destroy

  has_many :album_published_pictures, -> { album_published.includes_album }, class_name: 'AlbumPicture'
  has_many :event_published_pictures, -> { event_published.includes_event }, class_name: 'EventPicture'
  has_many :video_published_pictures, -> { video_published.includes_video }, class_name: 'VideoPicture'

  has_many :albums,   through: :album_pictures
  has_many :events,   through: :event_pictures
  has_many :keywords, through: :picture_keywords
  has_many :videos,   through: :video_pictures

  has_many :albums_published, through: :album_published_pictures, source: :album
  has_many :events_published, through: :event_published_pictures, source: :event
  has_many :videos_published, through: :video_published_pictures, source: :video

  has_many :infopage_items, as: :infopageable, dependent: :destroy
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
    album_pictures.to_a.sort_by! { |ap| ap.album.title_sortable }
  end

  def albums_sorted
    albums_sorted_by_title_asc
  end

  def albums_sorted_by_title_asc
    albums.to_a.sort_by! { |album| album.title_sortable }
  end

  def autokeyword
    if is_newly_built_and_has_unassigned_keyword
      joined_keywords[0]
    end
  end

  ### created_at

  ### credits_markup_type

  def credits_props
    { markup_type: credits_markup_type, markup_text: credits_markup_text }
  end

  ### credits_markup_text

  def date_released
    Time.new(0)
  end

  def datetime
    datetime_effective_value
  end

  ### datetime_cascade_method

  def datetime_props
    { method: datetime_effective_method, value: datetime_effective_value }
  end

  ### datetime_cascade_value

  def datetime_effective_method
    if datetime_from_manual_entry.to_s != ''
      'manual entry'
    elsif datetime_from_exif.to_s != ''
      'image metadata'
    elsif datetime_from_file.to_s != ''
      'filesystem'
    else
      'unknown'
    end
  end

  def datetime_effective_value
    case datetime_effective_method
    when 'manual entry'
      datetime_from_manual_entry.in_time_zone(datetime_from_manual_entry_zone)
    when 'image metadata'
      datetime_from_exif
    when 'filesystem'
      datetime_from_file
    when 'unknown'
      Time.new(0)
    end
  end

  ### datetime_from_exif

  ### datetime_from_file

  ### datetime_from_manual_entry

  ### datetime_from_manual_entry_zone




      ### datetime_from_manual_entry_year

      ### datetime_from_manual_entry_month

      ### datetime_from_manual_entry_day

      ### datetime_from_manual_entry_hour

      ### datetime_from_manual_entry_minute

      ### datetime_from_manual_entry_second



  def datetime_year
    case datetime
    when String
      Date.parse(datetime).year
    when Time
      datetime.year
    end
  end

  ### description_markup_type

  def description_props
    { markup_type: description_markup_type, markup_text: description_markup_text }
  end

  ### description_markup_text

  ### events_count

  def does_have_albums
    albums_count.to_i > 0
  end

  def does_have_albums_published
    albums_published.count.to_i > 0
  end

  def does_have_credits
    credits_markup_text.to_s != ''
  end

  def does_have_datetime
    datetime != Time.new(0)
  end

  def does_have_description
    description_markup_text != ''
  end

  def does_have_events
    events_count.to_i > 0
  end

  def does_have_events_published
    events_published.count.to_i > 0
  end

  def does_have_keywords
    keywords_count.to_i > 0
  end

  def does_have_source_uploaded
    self.source_uploaded.attached? == true
  end

  def does_have_title
    title_markup_text.to_s != ''
  end

  def does_have_videos
    videos_count.to_i > 0
  end

  def does_have_videos_published
    videos_published.count.to_i > 0
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
    event_pictures.to_a.sort_by! { |ep| ep.event.datetime_and_title }
  end

  def events_sorted
    events_sorted_by_title_asc
  end

  def events_sorted_by_title_asc
    events.to_a.sort_by! { |event| event.datetime_and_title }
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

  def is_joinable?
    ['public_indexable', 'public_joinable'].include?(visibility)
  end

  def is_newly_built_and_has_unassigned_keyword
    (id == nil) && (joined_keywords.length == 1) && (joined_keywords[0].id == nil)
  end

  def is_published?
    is_joinable? && is_released?
  end

  def is_released?
    if date_released
      date_released <= FindPublished.date_today
    end
  end

  def joined_albums
    album_pictures
  end

  def joined_albums_sorted
    album_pictures_sorted
  end

  def joined_events
    event_pictures
  end

  def joined_events_sorted
    event_pictures_sorted
  end

  def joined_keywords
    picture_keywords
  end

  def joined_keywords_sorted
    picture_keywords_sorted
  end

  def joined_videos
    video_pictures
  end

  def joined_videos_sorted
    video_pictures_sorted
  end

  ### keywords_count

  def keywords_sorted
    keywords_sorted_by_title_asc
  end

  def keywords_sorted_by_title_asc
    keywords.to_a.sort_by! { |keyword| keyword.title_sortable }
  end

  ### picture_keywords

  def picture_keywords_sorted
    picture_keywords_sorted_by_title_asc
  end

  def picture_keywords_sorted_by_title_asc
    picture_keywords.to_a.sort_by! { |pk| pk.keyword.title_sortable }
  end

  def should_generate_new_friendly_id?
    datetime_from_exif_changed? ||
    datetime_from_file_changed? ||
    datetime_from_manual_entry_changed? ||
    datetime_from_manual_entry_zone_changed? ||
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

  def title_props_for_display
    case title_markup_text
    when nil, ''
      { markup_type: 'inline', markup_text: '(untitled)' }
    else
      title_props
    end
  end

  def title_for_display
    case title_without_markup
    when nil, ''
      '(untitled)'
    else
      title_without_markup
    end
  end

  ### TODO: Deprecated
  # def title_for_html_head
  #   if title_without_markup.to_s == ''
  #     'untitled'
  #   else
  #     title_without_markup
  #   end
  # end

  ### title_markup_type

  def title_props
    { markup_type: title_markup_type, markup_text: title_markup_text }
  end

  ### title_markup_text

  def title_sortable
    title_without_markup.to_s.downcase
  end

  ### title_without_markup

  ### updated_at

  def video_pictures_sorted
    video_pictures_sorted_by_title_asc
  end

  def video_pictures_sorted_by_title_asc
    video_pictures.to_a.sort_by! { |vp| vp.video.title_sortable }
  end

  def videos_sorted
    videos_sorted_by_title_asc
  end

  def videos_sorted_by_title_asc
    videos.to_a.sort_by! { |video| video.title_sortable }
  end

  ### visibility


  private

  def create_attr_title_without_markup
    self.title_without_markup = ApplicationController.helpers.parser_remove_markup(self.title_props).strip.to_s
  end

  # def datetime_is_valid?
  #   begin
  #     if datetime_from_manual_entry_array_to_best_precision.any?
  #       DateTime === DateTime.new(*self.datetime_from_manual_entry_array_to_best_precision)
  #     end
  #   rescue Date::Error
  #     self.errors.add :base, :invalid_date, message: 'Invalid date.'
  #   end
  # end

  def source_absolute_path_to_file
    case source_type
    when 'uploaded'
      ActiveStorage::Blob.service.send(:path_for, source_uploaded.key)
    when 'imported'
      File.join(Rails.application.config.x.arlocal[:source_imported_filesystem_dirname], source_imported_file_path)
    end
  end

  def strip_any_leading_slash_from_source_imported_file_path
    if self.source_imported_file_path_changed? && self.source_imported_file_path[0] == File::SEPARATOR
      self.source_imported_file_path[0] = ''
    end
  end

  def strip_whitespace_edges_from_entered_text
    strippable_attributes = [
      'credits_markup_text',
      'description_markup_text',
      'source_imported_file_path',
      'title_markup_text'
    ]
    changed_strippable_attributes = self.changed.select { |v| strippable_attributes.include?(v) }
    changed_strippable_attributes.each do |attribute|
      stripped_value = self.read_attribute(attribute).to_s.strip
      self.write_attribute(attribute, stripped_value)
    end
  end

end
