class Event < ApplicationRecord


  extend FriendlyId
  extend MarkupParserUtils
  extend Neighborable
  include Seedable

  scope :only_future,         -> { where datetime_utc: Time.current.midnight.. }
  scope :only_future_near,    -> { where datetime_utc: Time.current.midnight...Time.current.next_month }
  scope :only_past,           -> { where datetime_utc: (..Time.current) }
  scope :only_with_audio,     -> { where audio_count:  1.. }
  scope :publicly_indexable,  -> { where visibility:   ['public'] }
  scope :publicly_linkable,   -> { where visibility:   ['public', 'unlisted'] }

  friendly_id :slug_candidates, use: :slugged

  before_validation :strip_whitespace_edges_from_entered_text
  before_validation :create_attr_title_without_markup

  validates :details_parser_id,        presence: true
  validates :event_pictures_sorter_id, presence: true
  validates :datetime_year,            presence: true
  validates :datetime_month,           presence: true
  validates :datetime_day,             presence: true
  validates :title_parser_id,          presence: true
  validates :title_text_markup,        presence: true
  validates :venue,                    presence: true

  before_save :convert_datetime_to_utc

  has_many :event_audio, -> { includes(:audio) }, dependent: :destroy
  has_many :audio, through: :event_audio

  has_many :event_pictures, -> { includes(:picture) }, dependent: :destroy
  has_many :pictures, through: :event_pictures

  has_one :coverpicture, -> { where(is_coverpicture: true).includes(:picture) }, class_name: 'EventPicture'

  has_many :event_keywords, -> { includes(:keyword) }, dependent: :destroy
  has_many :keywords, through: :event_keywords

  has_many :event_videos, -> { includes(:video) }, dependent: :destroy
  has_many :videos, through: :event_videos

  accepts_nested_attributes_for :audio
  accepts_nested_attributes_for :event_audio,    allow_destroy: true
  accepts_nested_attributes_for :event_keywords, allow_destroy: true, reject_if: proc { |attributes| attributes['keyword_id'] == '0' }
  accepts_nested_attributes_for :event_pictures, allow_destroy: true, reject_if: proc { |attributes| attributes['picture_id'] == '' }
  accepts_nested_attributes_for :event_videos,   allow_destroy: true
  accepts_nested_attributes_for :pictures
  accepts_nested_attributes_for :videos


  protected


  def self.datetime_array_attrs
    [ :datetime_year, :datetime_month, :datetime_day, :datetime_hour, :datetime_min, :datetime_zone ]
  end


  public


  ### alert


  ### audio


  ### audio_count


  def audio_published
    audio.select { |a| a.published == true }
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
    datetime_formatted(:year_month_day) + ' @ ' + venue
  end


  # event.datetime has several attributes instead of a single Datetime attribute
  # to allow for varying precision.

  def datetime
    Time.use_zone(datetime_zone) {
      Time.zone.local(
        datetime_year.to_i,
        datetime_month.to_i,
        datetime_day.to_i,
        datetime_hour.to_i,
        datetime_min.to_i
      )
    }
  end


  def datetime_friendly
    datetime.strftime('%Y-%m-%d %a %l:%M%P %Z')
  end


  def datetime_formatted(format)
    datetime.to_fs(format)
  end


  ### datetime_year
  ### datetime_month
  ### datetime_day
  ### datetime_hour
  ### datetime_min
  ### datetime_zone


  def datetime_and_title
    "#{datetime_formatted(:year_month_day)} / #{title_without_markup}"
  end


  ### details_parser_id


  def details_props
    { parser_id: details_parser_id, text_markup: details_text_markup  }
  end


  ### details_text_markup


  def does_have_audio
    audio_count.to_i > 0
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


  def does_have_venue
    venue.to_s != ''
  end


  def does_have_venue_url
    venue_url.to_s != ''
  end


  def does_have_videos
    videos_count.to_i > 0
  end


  ### event_audio


  def event_audio_published
    event_audio_sorted.select { |ea| ea.audio.published == true }
  end


  def event_audio_sorted
    event_audio_sorted_by_order_asc
  end


  def event_audio_sorted_by_order_asc
    event_audio.to_a.sort_by! { |ea| ea.event_order }
  end



  def event_keywords_sorted
    event_keywords_sorted_by_title_asc
  end


  def event_keywords_sorted_by_title_asc
    event_keywords.to_a.sort_by! { |ek| ek.keyword.title.downcase }
  end


  def event_pictures_published
    event_pictures_sorted.select { |ep| ep.picture.published == true }
  end


  def event_pictures_sorted
    if event_pictures_sorter
      event_pictures_sorter.call(event_pictures)
    else
      event_pictures
    end
  end


  def event_pictures_sorter
    SorterEventPictures.find(event_pictures_sorter_id)
  end


  ### event_pictures_sorter_id


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


  def joined_audio
    event_audio_sorted
  end


  def joined_keywords
    event_keywords_sorted
  end


  def joined_pictures
    event_pictures_sorted
  end


  ### id


  def id_admin
    friendly_id
  end


  def id_public
    friendly_id
  end


  ### keywords_count


  ### map_url


  ### pictures


  def pictures_all
    pictures
  end


  def pictures_all_sorted
    pictures_sorted
  end


  ### pictures_count


  def pictures_published
    pictures.select { |p| p.published == true }
  end


  def pictures_published_sorted
    event_pictures_published.map { |ep| ep.picture }
  end


  def pictures_sorted
    event_pictures_sorted.map { |ep| ep.picture }
  end


  def published
    ['public','unlisted'].include?(visibility)
  end


  def should_generate_new_friendly_id?
    datetime_year_changed? ||
    datetime_month_changed? ||
    datetime_day_changed? ||
    datetime_hour_changed? ||
    datetime_min_changed? ||
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
      :start_time_and_venue
    ]
  end


  def title
    title_without_markup
  end


  def title_props
    { parser_id: title_parser_id, text_markup: title_text_markup }
  end


  ### title_parser_id


  ### title_text_markup


  ### title_without_markup


  ### updated_at


  def update_and_recount_joined_resources(event_params)
    Event.reset_counters(id, :audio, :keywords, :pictures, :videos)
    update(event_params)
  end


  ### updated_at


  ### venue


  ### venue_url


  ### videos


  ### videos_count


  ### visibility



  private


  def create_attr_title_without_markup
    self.title_without_markup = ApplicationController.helpers.parser_remove_markup(self.title_props)
  end


  def convert_datetime_to_utc
    self.datetime_utc = self.datetime.utc
  end


  def strip_whitespace_edges_from_entered_text
    [ self.alert,
      self.city,
      self.details_text_markup,
      self.map_url,
      self.title_text_markup,
      self.venue,
      self.venue_url
    ].each { |a| a.to_s.strip! }
  end


end
