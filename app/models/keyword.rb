class Keyword < ApplicationRecord


  extend FriendlyId
  extend Neighborable
  include Seedable

  scope :only_that_can_select_videos,  -> { where(can_select_videos: true).order(order_selecting_videos: :asc) }
  scope :only_that_will_select_videos, -> { where(can_select_videos: true).where(videos_count: (1..)).order(order_selecting_videos: :asc) }

  friendly_id :slug_candidates, use: :slugged

  before_validation :strip_whitespace_edges_from_entered_text

  validates :title, presence: true, uniqueness: true

  has_many :album_keywords,   -> { includes(:album)   }, dependent: :destroy
  has_many :audio_keywords,   -> { includes(:audio)   }, dependent: :destroy
  has_many :event_keywords,   -> { includes(:event)   }, dependent: :destroy
  has_many :picture_keywords, -> { includes(:picture) }, dependent: :destroy
  has_many :video_keywords,   -> { includes(:video)   }, dependent: :destroy

  has_many :albums,   through: :album_keywords
  has_many :audio,    through: :audio_keywords
  has_many :events,   through: :event_keywords
  has_many :pictures, through: :picture_keywords
  has_many :videos,   through: :video_keywords

  accepts_nested_attributes_for :album_keywords,    allow_destroy: true
  accepts_nested_attributes_for :audio_keywords,    allow_destroy: true
  accepts_nested_attributes_for :event_keywords,    allow_destroy: true
  accepts_nested_attributes_for :picture_keywords,  allow_destroy: true, reject_if: proc { |attributes| attributes['picture_id'] == '' }
  accepts_nested_attributes_for :video_keywords,    allow_destroy: true


  public


  def album_keywords_sorted
    album_keywords_sorted_by_title_asc
  end


  def album_keywords_sorted_by_title_asc
    album_keywords.to_a.sort_by! { |ak| ak.album.title.downcase }
  end


  ### albums_count


  def albums_sorted
    albums_sorted_by_title_asc
  end


  def albums_sorted_by_title_asc
    albums.to_a.sort_by! { |album| album.title.downcase }
  end


  ### audio_count


  def audio_keywords_sorted
    audio_keywords_sorted_by_title_asc
  end


  def audio_keywords_sorted_by_title_asc
    audio_keywords.to_a.sort_by! { |ak| ak.audio.title.downcase }
  end


  def audio_sorted
    audio_sorted_by_title_asc
  end


  def audio_sorted_by_title_asc
    audio.to_a.sort_by! { |audio| audio.full_title.downcase }
  end


  def can_select
    ['albums', 'events', 'pictures', 'videos'].select{ |attr| can_select?(attr) == true }
  end


  def can_select?(resource_type = nil)
    case resource_type.to_s.downcase.pluralize
    when 'albums'
      can_select_albums
    when 'audio'
      can_select_audio
    when 'events'
      can_select_events
    when 'pictures'
      can_select_pictures
    when 'videos'
      can_select_videos
    when ''
      [ can_select_albums,
        can_select_audio,
        can_select_events,
        can_select_pictures,
        can_select_videos
      ].any?
    end
  end


  ### can_select_albums


  def can_select_audio
    false
  end


  ### can_select_events


  ### can_select_pictures


  ### can_select_videos


  ### created_at


  def does_have_albums
    albums_count.to_i > 0
  end


  def does_have_audio
    audio_count.to_i > 0
  end


  def does_have_events
    events_count.to_i > 0
  end


  def does_have_pictures
    pictures_count.to_i > 0
  end


  def does_have_videos
    videos_count.to_i > 0
  end


  def event_keywords_sorted
    event_keywords_sorted_by_datetime_asc
  end


  def event_keywords_sorted_by_datetime_asc
    event_keywords.to_a.sort_by! { |ek| ek.event.datetime }
  end


  ### events_count


  def events_sorted
    events_sorted_by_datetime_asc
  end


  def events_sorted_by_datetime_asc
    events.to_a.sort_by! { |event| event.datetime }
  end


  def events_sorted_by_title_asc
    events.to_a.sort_by! { |event| event.title }
  end


  ### id


  def id_admin
    friendly_id
  end


  def id_public
    friendly_id
  end


  def joined_albums
    album_keywords_sorted
  end


  def joined_audio
    audio_keywords_sorted
  end


  def joined_events
    event_keywords_sorted
  end


  def joined_pictures
    picture_keywords_sorted
  end


  def joined_videos
    video_keywords_sorted
  end


  ### order_selecting_albums


  ### order_selecting_events


  ### order_selecting_pictures


  ### order_selecting_videos


  def picture_keywords_sorted
    picture_keywords_sorted_by_title_asc
  end


  def picture_keywords_sorted_by_title_asc
    picture_keywords.to_a.sort_by! { |pk| pk.picture.title.downcase }
  end


  ### pictures_count


  def pictures_sorted
    pictures_sorted_by_title_asc
  end


  def pictures_sorted_by_title_asc
    pictures.to_a.sort_by! { |picture| picture.title.downcase }
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


  def slug_downcase
    slug.downcase
  end


  ### title


  def title_downcase
    title.downcase
  end


  # returns a string with title and number of joined audio
  def title_with_audio_count
    "#{title} (#{audio_count})"
  end


  # returns a string with title and number of joined pictures
  def title_with_pictures_count
    "#{self.title} (#{self.pictures_count})"
  end


  def title_with_videos_count
    "#{self.title} (#{self.videos_count})"
  end


  def update_and_recount_joined_resources(keyword_params)
    Keyword.reset_counters(id, :albums, :audio, :events, :pictures, :videos)
    update(keyword_params)
  end


  ### updated_at


  def video_keywords_sorted
    video_keywords_sorted_by_title_asc
  end


  def video_keywords_sorted_by_title_asc
    video_keywords.to_a.sort_by! { |vk| vk.video.title.downcase }
  end


  ### videos_count


  def videos_sorted
    videos_sorted_by_title_asc
  end


  def videos_sorted_by_title_asc
    videos.to_a.sort_by! { |video| video.title.downcase }
  end


  def will_select_public_pictures
    can_select_pictures && does_have_pictures
  end


  def will_select(resource_type: nil)
    case resource_type.to_s.downcase.singularize
    when 'picture'
      will_select_public_pictures
    end
  end


  private


  def strip_whitespace_edges_from_entered_text
    strippable_attributes = [
      'title'
    ]
    changed_strippable_attributes = self.changed.select { |v| strippable_attributes.include?(v) }
    changed_strippable_attributes.each do |a|
      stripped_attribute = self.read_attribute(a).to_s.strip
      self.write_attribute(a, stripped_attribute)
    end
  end


end
