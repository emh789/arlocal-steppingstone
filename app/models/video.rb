class Video < ApplicationRecord

  extend FriendlyId
  extend Neighborable
  extend Paginateable

  scope :future,    -> { where('date_released >  ?', FindPublished.date_today) }
  scope :released,  -> { where('date_released <= ?', FindPublished.date_today) }
  scope :published, -> { any_public_released_joinable }

  scope :all_public_indexable,  -> { where(visibility: ['public_indexable']) }
  scope :all_public_joinable,   -> { where(visibility: ['public_indexable', 'public_joinable']) }
  scope :all_public_showable,   -> { where(visibility: ['public_indexable', 'public_joinable', 'public_showable']) }

  scope :any_public_released_indexable,   -> { released.all_public_indexable }
  scope :any_public_released_joinable,    -> { released.all_public_joinable }
  scope :any_public_released_or_showable, -> { (Video.any_public_released_joinable).or(Video.only_public_showable) }

  scope :any_with_keyword, ->(keyword) { joins(:keyword).where(keywords: keyword) }

  scope :only_public_indexable, -> { where(visibility: 'public_indexable') }
  scope :only_public_joinable,  -> { where(visibility: 'public_joinable') }
  scope :only_public_showable,  -> { where(visibility: 'public_showable') }
  scope :only_admin_only,       -> { where(visibility: 'admin_only') }

  scope :with_keywords_matching,            ->(keywords)  { joins(:keywords).where(keywords: keywords) }
  scope :without_any_keywords,              ->            { where(keywords_count: 0) }
  scope :without_keywords_matching,         ->(keywords)  { joins(:keywords).where.not(keywords: keywords) }
  scope :without_any_or_matching_keywords,  ->(keywords)  { without_keywords_matching(keywords) + without_any_keywords }

  scope :include_everything,  -> { includes_events.includes_keywords.includes_pictures }
  scope :includes_events,     -> { includes(:events) }
  scope :includes_keywords,   -> { includes(:keywords) }
  scope :includes_pictures,   -> { includes({ pictures: :source_uploaded_attachment })}

  friendly_id :slug_candidates, use: :slugged

  before_validation :strip_whitespace_edges_from_entered_text

  validates :isrc_country_code,       allow_blank: true, length: { is: 2 }
  validates :isrc_designation_code,   allow_blank: true, length: { is: 5 }, uniqueness: { scope: :isrc_year_of_reference }
  validates :isrc_registrant_code,    allow_blank: true, length: { is: 3 }
  validates :isrc_year_of_reference,  allow_blank: true, length: { is: 2 }

  has_many :event_videos,   -> { includes_event },   dependent: :destroy
  has_many :video_keywords, -> { includes_keyword }, dependent: :destroy
  has_many :video_pictures, -> { includes_picture }, dependent: :destroy

  has_many :event_published_videos,   -> { events_published.includes_event },     class_name: 'EventVideo'
  has_many :video_pictures_published, -> { pictures_published.includes_picture }, class_name: 'VideoPicture'

  has_many :events,   through: :event_videos
  has_many :keywords, through: :video_keywords
  has_many :pictures, through: :video_pictures

  has_many :events_published,   through: :event_published_pictures, source: :event
  has_many :pictures_published, through: :video_pictures_published, source: :picture

  has_one :coverpicture, -> { is_coverpicture.includes_picture }, class_name: 'VideoPicture'

  has_one_attached :source_uploaded

  accepts_nested_attributes_for :event_videos, allow_destroy: true
  accepts_nested_attributes_for :events
  accepts_nested_attributes_for :keywords
  accepts_nested_attributes_for :pictures
  accepts_nested_attributes_for :video_keywords, allow_destroy: true, reject_if: proc { |attributes| attributes['keyword_id'] == '0' }
  accepts_nested_attributes_for :video_pictures, allow_destroy: true, reject_if: proc { |attributes| attributes['picture_id'] == ''  }


  protected

  def self.source_type_options
    [:attachment, :imported, :embed, :url]
  end

  def self.source_type_options_for_select
    Video.source_type_options.map{ |option| [option, option] }
  end


  public

  def autokeyword
    if is_newly_built_and_has_unassigned_keyword
      joined_keywords[0]
    end
  end

  ### copyright_markup_type

  def copyright_props
    { markup_type: copyright_markup_type, markup_text: copyright_markup_text }
  end

  ### copyright_markup_text

  def coverpicture_source_imported_file_path
    if does_have_coverpicture
      coverpicture.picture_source_imported_file_path
    end
  end

  def coverpicture_picture
    if does_have_coverpicture
      coverpicture.picture
    end
  end

  def coverpicture_picture_id
    if does_have_coverpicture
      coverpicture.picture.id
    end
  end

  def coverpicture_slug
    if does_have_coverpicture
      coverpicture.picture.slug
    end
  end

  ### date_released

  def date_released_sortable
    date_released ? date_released : Date.new(0)
  end

  ### description_markup_type

  def description_props
    { markup_type: description_markup_type, markup_text: description_markup_text }
  end

  ### description_markup_text

  def display_dimension_width
    640
  end

  def display_dimension_height
    (source_dimension_height * display_dimension_width) / source_dimension_width
  end

  def does_have_attached(attribute)
    case attribute
    when :source_uploaded
      self.source_uploaded.attached? == true
    end
  end

  def does_have_coverpicture
    coverpicture && coverpicture.picture
  end

  def does_have_events
    events_count.to_i > 0
  end

  def does_have_events_published
    events_published_count.to_i > 0
  end

  def does_have_keywords
    keywords_count.to_i > 0
  end

  def does_have_pictures
    pictures_count.to_i > 0
  end

  def does_have_pictures_published
    pictures_published_count.to_i > 0
  end

  def does_have_source_uploaded
    self.source_uploaded.attached? == true
  end

  def does_not_have_attached(attribute)
    case attribute
    when :source_uploaded
      self.source_uploaded.attached? == false
    end
  end

  def does_not_have_source_uploaded
    self.source_uploaded.attached? == false
  end

  def event_videos_sorted
    event_videos_sorted_by_title_asc
  end

  def event_videos_sorted_by_datetime_asc
    event_videos.to_a.sort_by! { |ev| ev.event.datetime_utc_sortable }
  end

  def event_videos_sorted_by_title_asc
    event_videos.to_a.sort_by! { |ev| ev.event.title_sortable.downcase }
  end

  ### events

  ### events_count

  def full_title
    title
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

  def joined_events
    event_videos
  end

  def joined_events_sorted
    event_videos_sorted
  end

  def joined_keywords
    video_keywords
  end

  def joined_keywords_sorted
    video_keywords_sorted
  end

  def joined_pictures
    video_pictures
  end

  def joined_pictures_sorted
    video_pictures_sorted
  end

  ### keywords_count

  def keywords_sorted
    keywords_sorted_by_title_asc
  end

  def keywords_sorted_by_title_asc
    keywords.to_a.sort_by! { |keyword| keyword.title_sortable.downcase }
  end

  ### personnel_markup_type

  def personnel_props
    { markup_type: personnel_markup_type, markup_text: personnel_markup_text }
  end

  ### personnel_markup_text

  ### pictures_count

  def pictures_sorted
    pictures_sorted_by_title_asc
  end

  def pictures_sorted_by_title_asc
    pictures.to_a.sort_by! { |picture| picture.title_sortable }
  end

  def should_generate_new_friendly_id?
    title_changed? ||
    super
  end

  ### slug

  def slug_candidates
    [
      [:title]
    ]
  end

  def source_uploaded_file_path
    source_uploaded.blob.filename.to_s
  end

  ### source_imported_file_path

  ### source_dimension_height

  ### source_dimension_width

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
    when 'attachment'
      source_uploaded_file_path
    when 'imported'
      source_imported_file_path
    when 'url'
      false
    end
  end

  def source_is_embed
    case source_type
    when 'embed'
      true
    else
      false
    end
  end

  def source_is_file
    case source_type
    when 'attachment'
      true
    when 'imported'
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

  def source_location
    case source_type
    when 'attachment'
      source_file_path
    when 'imported'
      source_file_path
    when 'url'
      source_url
    end
  end

  ### source_type

  ### source_url

  ### title

  def title_sortable
    title.to_s
  end

  def video_keywords_sorted
    video_keywords_sorted_by_title_asc
  end

  def video_keywords_sorted_by_title_asc
    video_keywords.to_a.sort_by! { |vk| vk.keyword.title_sortable.downcase }
  end

  def video_pictures_sorted
    video_pictures_sorted_by_title_asc
  end

  def video_pictures_sorted_by_title_asc
    video_pictures.to_a.sort_by! { |vp| vp.picture.title_sortable.downcase }
  end

  ### visibility

  def year
    if date_released
      date_released.year
    end
  end


  private

  def strip_whitespace_edges_from_entered_text
    strippable_attributes = [
      'copyright_markup_text',
      'description_markup_text',
      'personnel_markup_text',
      'title',
    ]
    changed_strippable_attributes = self.changed.select { |v| strippable_attributes.include?(v) }
    changed_strippable_attributes.each do |attribute|
      stripped_value = self.read_attribute(attribute).to_s.strip
      self.write_attribute(attribute, stripped_value)
    end
  end

end
