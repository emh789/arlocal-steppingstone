class Event < ApplicationRecord

  extend FriendlyId
  extend Neighborable

  scope :announced,     -> { all }
  scope :future,        -> { where(datetime_utc: (Time.current.midnight..)) }
  scope :past,          -> { where(datetime_utc: (..Time.current)) }
  scope :published,     -> { any_public_announced_joinable }
  scope :upcoming,      -> { where(datetime_utc: (Time.current.midnight...Time.current.next_month)) }
  scope :with_audio,    -> { where(audio_count:     1..) }
  scope :with_pictures, -> { where(pictures_count:  1..) }
  scope :with_videos,   -> { where(videos_count:    1..) }

  scope :all_public_indexable,  -> { where(visibility: ['public_indexable']) }
  scope :all_public_joinable,   -> { where(visibility: ['public_indexable', 'public_joinable']) }
  scope :all_public_showable,   -> { where(visibility: ['public_indexable', 'public_joinable', 'public_showable']) }

  scope :any_public_announced_indexable,   -> { announced.all_public_indexable }
  scope :any_public_announced_joinable,    -> { announced.all_public_joinable }
  scope :any_public_announced_or_showable, -> { (Event.any_public_announced_joinable).or(Event.only_public_showable) }

  scope :only_public_indexable, -> { where(visibility: 'public_indexable') }
  scope :only_public_joinable,  -> { where(visibility: 'public_joinable') }
  scope :only_public_showable,  -> { where(visibility: 'public_showable') }
  scope :only_admin_only,       -> { where(visibility: 'admin_only') }

  scope :include_everything,  -> { includes_audio.includes_pictures.includes_videos }
  scope :includes_audio,      -> { includes({ audio: :source_uploaded_attachment }) }
  scope :includes_pictures,   -> { includes({ pictures: :source_uploaded_attachment })}
  scope :includes_videos,     -> { includes({ videos: :source_uploaded_attachment }) }

  friendly_id :slug_candidates, use: :slugged

  before_validation :strip_whitespace_edges_from_entered_text

  validates :datetime_year,               presence: true
  validates :datetime_month,              presence: true
  validates :datetime_day,                presence: true
  validates :details_markup_type,         presence: true
  validates :event_pictures_sort_method,  presence: true
  validates :title_markup_type,           presence: true
  validates :title_markup_text,           presence: true
  validates :venue,                       presence: true

  before_save :create_attr_title_without_markup

  has_many :event_audio,    -> { includes_audio },   dependent: :destroy
  has_many :event_keywords, -> { includes_keyword }, dependent: :destroy
  has_many :event_pictures, -> { includes_picture }, dependent: :destroy
  has_many :event_videos,   -> { includes_video },   dependent: :destroy

  has_many :event_audio_published,    -> { audio_published.includes_audio },      class_name: 'EventAudio'
  has_many :event_pictures_published, -> { pictures_published.includes_picture }, class_name: 'EventPicture'
  has_many :event_videos_published,   -> { videos_published.includes_video },     class_name: 'EventPicture'

  has_many :audio,    through: :event_audio
  has_many :keywords, through: :event_keywords
  has_many :pictures, through: :event_pictures
  has_many :videos,   through: :event_videos

  has_many :audio_published,    through: :event_audio_published,    source: :audio
  has_many :pictures_published, through: :event_pictures_published, source: :picture
  has_many :videos_published,   through: :event_videos_published,   source: :video

  has_one :coverpicture, -> { is_coverpicture.includes_picture }, class_name: 'EventPicture'

  accepts_nested_attributes_for :audio
  accepts_nested_attributes_for :event_audio,    allow_destroy: true
  accepts_nested_attributes_for :event_keywords, allow_destroy: true, reject_if: proc { |attributes| attributes['keyword_id'] == '0' }
  accepts_nested_attributes_for :event_pictures, allow_destroy: true, reject_if: proc { |attributes| attributes['picture_id'] == ''  }
  accepts_nested_attributes_for :event_videos,   allow_destroy: true
  accepts_nested_attributes_for :pictures
  accepts_nested_attributes_for :videos


  public

  ### alert

  ### audio

  ### audio_count

  def audio_sorted
    audio_sorted_by_title_asc
  end

  def audio_sorted_by_title_asc
    audio.to_a.sort_by! { |audio| audio.full_title.downcase }
  end

  def autokeyword
    if is_newly_built_and_has_unassigned_keyword
      joined_keywords[0]
    end
  end

  ### city

  def coverpicture_source_imported_file_path
    if does_have_coverpicture
      coverpicture.picture.source_imported_file_path
    end
  end

  def coverpicture_picture
    if does_have_coverpicture
      coverpicture.picture
    end
  end

  def coverpicture_slug
    if does_have_coverpicture
      coverpicture.picture.slug
    end
  end

  ### created_at

  def date_and_venue
    datetime_local_formatted(:year_month_day) + ' @ ' + venue
  end

  def datetime
    datetime_local
  end

  def datetime_day
    if datetime_local
      datetime_local.day
    end
  end

  def datetime_friendly
    datetime_local.strftime('%Y.%m.%d %a %l:%M%P %Z')
  end

  def datetime_hour
    if datetime_local
      datetime_local.hour
    end
  end

  def datetime_min
    if datetime_local
      datetime_local.min
    end
  end

  def datetime_local
    if datetime_utc
      datetime_utc.in_time_zone(datetime_zone)
    end
  end

  def datetime_local_formatted(format)
    datetime_local.to_fs(format)
  end

  def datetime_month
    if datetime_local
      datetime_local.month
    end
  end

  def datetime_sortable
    datetime_utc_sortable
  end

  ### datetime_utc

  def datetime_utc_sortable
    if datetime_utc
      datetime_utc
    else
      Time.new(0)
    end
  end

  def datetime_year
    if datetime_local
      datetime_local.year
    end
  end

  ### datetime_zone

  def datetime_and_title
    "#{datetime_local_formatted(:year_month_day)} / #{title_without_markup}"
  end

  ### details_markup_text

  ### details_markup_type

  def details_props
    { markup_type: details_markup_type, markup_text: details_markup_text  }
  end

  def does_have_audio
    audio_count.to_i > 0
  end

  def does_have_audio_published
    audio.published.count.to_i > 0
  end

  def does_have_alert
    alert.to_s != ''
  end

  def does_have_city
    city.to_s != ''
  end

  def does_have_city_and_venue
    does_have_city && does_have_venue
  end

  def does_have_coverpicture
    (coverpicture) && (coverpicture.picture)
  end

  def does_have_keywords
    keywords_count.to_i > 0
  end

  def does_have_map_url
    map_url.to_s != ''
  end

  def does_have_more_than_one_audio
    audio_count.to_i > 1
  end

  def does_have_more_than_one_picture
    pictures_count.to_i > 1
  end

  def does_have_pictures
    pictures_count.to_i > 0
  end

  def does_have_pictures_published
    pictures_published.count.to_i > 0
  end

  def does_have_venue
    venue.to_s != ''
  end

  def does_have_venue_url
    venue_url.to_s != ''
  end

  def does_have_videos
    videos_count.to_i > 0
  end

  def does_have_videos_published
    videos_published.count.to_i > 0
  end

  ### event_audio

  def event_audio_published_sorted
    event_audio_published_sorted_by_event_order_asc
  end

  def event_audio_published_sorted_by_event_order_asc
    event_audio_published.to_a.sort_by! { |ea| ea.event_order.to_i }
  end

  def event_audio_sorted
    event_audio_sorted_by_order_asc
  end

  def event_audio_sorted_by_order_asc
    event_audio.to_a.sort_by! { |ea| ea.event_order.to_i }
  end

  def event_keywords_sorted
    event_keywords_sorted_by_title_asc
  end

  def event_keywords_sorted_by_title_asc
    event_keywords.to_a.sort_by! { |ek| ek.keyword.title_sortable.downcase }
  end

  def event_pictures_published_sorted
    if event_pictures_sorter
      event_pictures_sorter.call(event_pictures_published)
    else
      event_pictures_published
    end
  end

  ### event_pictures_sort_method

  def event_pictures_sorted
    if event_pictures_sorter
      event_pictures_sorter.call(event_pictures)
    else
      event_pictures
    end
  end

  def event_pictures_sorter
    SorterEventPictures.find(event_pictures_sort_method)
  end

  ### event_videos

  def event_videos_sorted
    event_videos_sorted_by_order_asc
  end

  def event_videos_sorted_by_title_asc
    event_videos.to_a.sort_by! { |ev| ev.event_order}
  end

  def full_title
    datetime_and_title
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

  def is_announced?
    if date_announced
      date_announced <= FindPublished.date_today
    end
  end

  def is_newly_built_and_has_unassigned_keyword
    (id == nil) && (joined_keywords.length == 1) && (joined_keywords[0].id == nil)
  end

  def is_published?
    is_joinable? && is_announced?
  end

  def joined_audio
    event_audio
  end

  def joined_audio_sorted
    event_audio_sorted
  end

  def joined_keywords
    event_keywords
  end

  def joined_keywords_sorted
    event_keywords_sorted
  end

  def joined_pictures
    event_pictures
  end

  def joined_pictures_sorted
    event_pictures_sorted
  end

  ### keywords_count

  def keywords_sorted
    keywords_sorted_by_title_asc
  end

  def keywords_sorted_by_title_asc
    keywords.to_a.sort_by! { |keyword| keyword.title_sortable.downcase }
  end

  ### map_url

  ### pictures

  ### pictures_count

  def pictures_published_sorted
    event_pictures_published.map { |ep| ep.picture }
  end

  def pictures_sorted
    event_pictures_sorted.map { |ep| ep.picture }
  end

  def should_generate_new_friendly_id?
    datetime_utc_changed? ||
    venue_changed? ||
    super
  end

  ### show_can_cycle_pictures

  ### show_can_have_more_pictures_link

  def show_will_cycle_pictures
    show_can_cycle_pictures && does_have_more_than_one_picture
  end

  def show_will_have_more_pictures_link
    show_can_have_more_pictures_link && does_have_more_than_one_picture
  end

  ### slug

  def slug_candidates
    [
      :date_and_venue
    ]
  end

  def title
    title_without_markup
  end

  ### title_markup_type

  ### title_markup_text

  def title_props
    { markup_type: title_markup_type, markup_text: title_markup_text }
  end

  def title_sortable
    title.to_s
  end

  ### title_without_markup

  ### updated_at

  ### venue

  ### venue_url

  ### videos

  ### videos_count

  ### visibility


  private

  def create_attr_title_without_markup
    self.title_without_markup = ApplicationController.helpers.parser_remove_markup(self.title_props).strip.to_s
  end

  def strip_whitespace_edges_from_entered_text
    strippable_attributes = [
      'alert',
      'city',
      'details_markup_text',
      'map_url',
      'title_markup_text',
      'venue',
      'venue_url'
    ]
    changed_strippable_attributes = self.changed.select { |v| strippable_attributes.include?(v) }
    changed_strippable_attributes.each do |attribute|
      stripped_value = self.read_attribute(attribute).to_s.strip
      self.write_attribute(attribute, stripped_value)
    end
  end

end
