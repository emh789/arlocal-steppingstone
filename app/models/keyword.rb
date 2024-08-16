class Keyword < ApplicationRecord

  extend FriendlyId
  extend Neighborable

  scope :can_select_videos,-> { where(can_select_videos: true) }

  scope :will_select_published_videos,  -> { can_select_videos.with_videos_published }
  scope :with_videos,                   -> { where(videos_count: 1..) }
  scope :with_videos_published,         -> { where(videos_published_count: 1..) }

  scope :include_everything,  -> { includes_albums.includes_articles.includes_audio.includes_events.includes_pictures.includes_videos }
  scope :includes_albums,     -> { includes(:albums) }
  scope :includes_articles,   -> { includes(:articles) }
  scope :includes_audio,      -> { includes({ audio: :source_uploaded_attachment }) }
  scope :includes_events,     -> { includes(:events) }
  scope :includes_pictures,   -> { includes({ pictures: :source_uploaded_attachment }) }
  scope :includes_videos,     -> { includes(:videos) }

  friendly_id :slug_candidates, use: :slugged

  before_validation :strip_whitespace_edges_from_entered_text

  validates :title, presence: true, uniqueness: true

  has_many :album_keywords,   -> { includes_album },    dependent: :destroy
  has_many :article_keywords, -> { includes_article },  dependent: :destroy
  has_many :audio_keywords,   -> { includes_audio },    dependent: :destroy
  has_many :event_keywords,   -> { includes_event },    dependent: :destroy
  has_many :picture_keywords, -> { includes_picture },  dependent: :destroy
  has_many :video_keywords,   -> { includes_video },    dependent: :destroy

  has_many :album_published_keywords,   -> { albums_published.includes_album },     class_name: 'AlbumKeyword'
  has_many :article_published_keywords, -> { articles_published.includes_article }, class_name: 'ArticleKeyword'
  has_many :event_published_keywords,   -> { events_published.includes_event },     class_name: 'EventKeyword'
  has_many :audio_published_keywords,   -> { audio_published.includes_audio },      class_name: 'AudioKeyword'
  has_many :picture_published_keywords, -> { pictures_published.includes_picture }, class_name: 'PictureKeyword'
  has_many :video_published_keywords,   -> { videos_published.includes_video },     class_name: 'VideoKeyword'

  has_many :albums,   through: :album_keywords
  has_many :articles, through: :article_keywords
  has_many :audio,    through: :audio_keywords
  has_many :events,   through: :event_keywords
  has_many :pictures, through: :picture_keywords
  has_many :videos,   through: :video_keywords

  has_many :albums_published,   through: :album_published_keywords,   source: :album
  has_many :articles_published, through: :article_published_keywords, source: :article
  has_many :audio_published,    through: :audio_published_keywords,   source: :audio
  has_many :events_published,   through: :event_published_keywords,   source: :event
  has_many :pictures_published, through: :picture_published_keywords, source: :picture
  has_many :videos_published,   through: :video_published_keywords,   source: :video

  accepts_nested_attributes_for :album_keywords,    allow_destroy: true
  accepts_nested_attributes_for :article_keywords,  allow_destroy: true
  accepts_nested_attributes_for :audio_keywords,    allow_destroy: true
  accepts_nested_attributes_for :event_keywords,    allow_destroy: true
  accepts_nested_attributes_for :picture_keywords,  allow_destroy: true, reject_if: proc { |attributes| attributes['picture_id'] == '' }
  accepts_nested_attributes_for :video_keywords,    allow_destroy: true


  public

  def album_keywords_sorted
    album_keywords_sorted_by_title_asc
  end

  def album_keywords_sorted_by_title_asc
    album_keywords.to_a.sort_by! { |ak| ak.album.title_sortable.downcase }
  end

  ### albums_count

  def albums_sorted
    albums_sorted_by_title_asc
  end

  def albums_sorted_by_title_asc
    albums.to_a.sort_by! { |album| album.title_sortable.downcase }
  end

  ### audio_count

  def audio_keywords_sorted
    audio_keywords_sorted_by_title_asc
  end

  def audio_keywords_sorted_by_title_asc
    audio_keywords.to_a.sort_by! { |ak| ak.audio.full_title.downcase }
  end

  def audio_sorted
    audio_sorted_by_title_asc
  end

  def audio_sorted_by_title_asc
    audio.to_a.sort_by! { |audio| audio.full_title.downcase }
  end

  def can_select
    ['albums', 'audio', 'events', 'pictures', 'videos'].select{ |attr| can_select?(attr) == true }
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
      can_select_any?
    end
  end

  ### can_select_albums

  def can_select_any?
    [ can_select_albums,
      can_select_audio,
      can_select_events,
      can_select_pictures,
      can_select_videos
    ].any?
  end

  ### can_select_audio

  ### can_select_events

  ### can_select_pictures

  ### can_select_videos

  ### created_at

  def does_have_albums
    albums_count.to_i > 0
  end

  def does_have_albums_published
    albums_count_published.to_i > 0
  end

  def does_have_audio
    audio_count.to_i > 0
  end

  def does_have_audio_published
    audio_count_published.to_i > 0
  end

  def does_have_events
    events_count.to_i > 0
  end

  def does_have_events_published
    events_count_published.to_i > 0
  end

  def does_have_pictures
    pictures_count.to_i > 0
  end

  def does_have_pictures_published
    pictures_count_published.to_i > 0
  end

  def does_have_videos
    videos_count.to_i > 0
  end

  def does_have_videos_published
    videos_count_published.to_i > 0
  end

  def event_keywords_sorted
    event_keywords_sorted_by_datetime_asc
  end

  def event_keywords_sorted_by_datetime_asc
    event_keywords.to_a.sort_by! { |ek| ek.event.datetime_sortable }
  end

  ### events_count

  def events_sorted
    events_sorted_by_datetime_asc
  end

  def events_sorted_by_datetime_asc
    events.to_a.sort_by! { |event| event.datetime_utc_sortable }
  end

  def events_sorted_by_title_asc
    events.to_a.sort_by! { |event| event.title_sortable }
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
    picture_keywords.to_a.sort_by! { |pk| pk.picture.title_sortable.downcase }
  end

  ### pictures_count

  def pictures_sorted
    pictures_sorted_by_title_asc
  end

  def pictures_sorted_by_title_asc
    pictures.to_a.sort_by! { |picture| picture.title_sortable.downcase }
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

  ### title

  def title_sortable
    title.to_s.downcase
  end

  def title_with_audio_count
    "#{title} (#{audio_count})"
  end

  def title_with_pictures_count
    "#{title} (#{pictures_count})"
  end

  def title_with_videos_count
    "#{title} (#{videos_count})"
  end

  ### updated_at

  def video_keywords_sorted
    video_keywords_sorted_by_title_asc
  end

  def video_keywords_sorted_by_title_asc
    video_keywords.to_a.sort_by! { |vk| vk.video.title_sortable.downcase }
  end

  ### videos_count

  def videos_sorted
    videos_sorted_by_title_asc
  end

  def videos_sorted_by_title_asc
    videos.to_a.sort_by! { |video| video.title_sortable.downcase }
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
    changed_strippable_attributes.each do |attribute|
      stripped_value = self.read_attribute(attribute).to_s.strip
      self.write_attribute(attribute, stripped_value)
    end
  end

end
