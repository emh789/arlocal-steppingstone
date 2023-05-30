class Video < ApplicationRecord


  extend FriendlyId
  extend MarkupParserUtils
  extend Neighborable
  extend Paginateable
  include Seedable

  scope :order_by_datetime_asc,  -> { order(date_released: :asc ) }
  scope :order_by_datetime_desc, -> { order(date_released: :desc) }
  scope :order_by_title_asc,     -> { order(Video.arel_table[:title].lower.asc ) }
  scope :order_by_title_desc,    -> { order(Video.arel_table[:title].lower.desc) }
  scope :publicly_indexable, -> { where(visibility: ['public']) }
  scope :publicly_linkable,  -> { where(visibility: ['public', 'unlisted']) }

  friendly_id :slug_candidates, use: :slugged

  before_validation :strip_whitespace_edges_from_entered_text

  validates :isrc_country_code, allow_blank: true, length: { is: 2 }
  validates :isrc_designation_code, allow_blank: true, length: { is: 5 }, uniqueness: { scope: :isrc_year_of_reference }
  validates :isrc_registrant_code, allow_blank: true, length: { is: 3 }
  validates :isrc_year_of_reference, allow_blank: true, length: { is: 2 }

  has_many :event_videos, dependent: :destroy
  has_many :events, through: :event_videos

  has_many :video_keywords, dependent: :destroy
  has_many :keywords, through: :video_keywords

  has_many :video_pictures, -> { includes(:picture) }, dependent: :destroy
  has_many :pictures, through: :video_pictures
  
  has_one :coverpicture, -> { where is_coverpicture: true }, class_name: 'VideoPicture'


  has_one_attached :source_uploaded

  accepts_nested_attributes_for :event_videos, allow_destroy: true
  accepts_nested_attributes_for :events
  accepts_nested_attributes_for :keywords
  accepts_nested_attributes_for :pictures
  accepts_nested_attributes_for :video_keywords, allow_destroy: true, reject_if: proc { |attributes| attributes['keyword_id'] == '0' }
  accepts_nested_attributes_for :video_pictures, allow_destroy: true, reject_if: proc { |attributes| attributes['picture_id'] == '' }



  protected


  def self.source_type_options
    [:attachment, :imported, :embed, :url]
  end


  def self.source_type_options_for_select
    Video.source_type_options.map{ |option| [option, option] }
  end



  public


  ### copyright_parser_id


  def copyright_props
    { parser_id: copyright_parser_id, text_markup: copyright_text_markup }
  end


  ### copyright_text_markup


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


  ### description_parser_id


  def description_props
    { parser_id: description_parser_id, text_markup: description_text_markup }
  end


  ### description_text_markup


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


  def does_have_keywords
    keywords_count.to_i > 0
  end


  def does_have_pictures
    pictures_count.to_i > 0
  end


  def does_not_have_attached(attribute)
    case attribute
    when :source_uploaded
      self.source_uploaded.attached? == false
    end
  end


  def event_videos_sorted
    event_videos_sorted_by_title_asc
  end


  def event_videos_sorted_by_title_asc
    event_videos.to_a.sort_by! { |ev| ev.event.title.downcase }
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
    event_videos_sorted
  end


  def joined_keywords
    video_keywords_sorted
  end


  def joined_pictures
    video_pictures_sorted
  end


  ### keywords_count


  ### personnel_parser_id


  def personnel_props
    { parser_id: personnel_parser_id, text_markup: personnel_text_markup }
  end


  ### personnel_text_markup


  ### pictures_count


  def published
    ['public','unlisted'].include?(visibility)
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


  def update_and_recount_joined_resources(video_params)
    Video.reset_counters(id, :events, :keywords, :pictures)
    update(video_params)
  end


  def video_keywords_sorted
    video_keywords_sorted_by_title_asc
  end


  def video_keywords_sorted_by_title_asc
    video_keywords.to_a.sort_by! { |vk| vk.keyword.title.downcase }
  end


  def video_pictures_sorted
    video_pictures_sorted_by_title_asc
  end


  def video_pictures_sorted_by_title_asc
    video_pictures.to_a.sort_by! { |vp| vp.picture.title_without_markup.downcase }
  end


  ### visibility


  def year
    if date_released
      date_released.year
    end
  end



  private


  def strip_whitespace_edges_from_entered_text
    [ self.copyright_text_markup,
      self.description_text_markup,
      self.personnel_text_markup,
      self.title,
    ].select{ |a| a.to_s != '' }.each { |a| a.to_s.strip! }
  end


end
