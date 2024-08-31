class Album < ApplicationRecord

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
  scope :any_public_released_or_showable, -> { (Album.any_public_released_joinable).or(Album.only_public_showable) }

  scope :only_public_indexable, -> { where(visibility: 'public_indexable') }
  scope :only_public_joinable,  -> { where(visibility: 'public_joinable') }
  scope :only_public_showable,  -> { where(visibility: 'public_showable') }
  scope :only_admin_only,       -> { where(visibility: 'admin_only') }

  scope :include_everything,  -> { includes_audio.includes_keywords.includes_pictures }
  scope :includes_audio,      -> { includes({ audio: :source_uploaded_attachment }) }
  scope :includes_keywords,   -> { includes(:keywords) }
  scope :includes_pictures,   -> { includes({ pictures: :source_uploaded_attachment })}

  friendly_id :slug_candidates, use: :slugged

  before_validation :strip_whitespace_edges_from_entered_text

  validates :album_pictures_sort_method,  presence: true
  validates :description_markup_type,     presence: true
  validates :title,                       presence: true

  has_many :album_audio,    -> { includes_audio },    dependent: :destroy
  has_many :album_keywords, -> { includes_keyword },  dependent: :destroy
  has_many :album_pictures, -> { includes_picture },  dependent: :destroy

  has_many :album_audio_published,    -> { audio_published.includes_audio },      class_name: 'AlbumAudio'
  has_many :album_pictures_published, -> { pictures_published.includes_picture }, class_name: 'AlbumPicture'

  has_many :audio,    through: :album_audio
  has_many :keywords, through: :album_keywords
  has_many :pictures, through: :album_pictures

  has_many :audio_published,    through: :album_audio_published,    source: :audio
  has_many :pictures_published, through: :album_pictures_published, source: :picture

  has_one :coverpicture, -> { is_coverpicture.includes_picture }, class_name: 'AlbumPicture'

  accepts_nested_attributes_for :album_audio,    allow_destroy: true
  accepts_nested_attributes_for :album_keywords, allow_destroy: true, reject_if: proc { |attributes| attributes['keyword_id'] == '0' }
  accepts_nested_attributes_for :album_pictures, allow_destroy: true, reject_if: proc { |attributes| attributes['picture_id'] == ''  }
  accepts_nested_attributes_for :audio
  accepts_nested_attributes_for :pictures


  public

  ### album_artist

  def album_audio_published_sorted
    album_audio_published_sorted_by_album_order_asc
  end

  def album_audio_published_sorted_by_album_order_asc
    album_audio_published.to_a.sort_by! { |aa| aa.album_order.to_i }
  end

  def album_audio_sorted
    album_audio.to_a.sort_by! { |aa| aa.album_order.to_i }
  end

  def album_keywords_sorted
    album_keywords_sorted_by_title_asc
  end

  def album_keywords_sorted_by_title_asc
    album_keywords.to_a.sort_by! { |ak| ak.keyword.title_sortable.downcase }
  end

  def album_pictures_published_sorted
    sorter = album_pictures_sorter
    if sorter
      sorter.call(album_pictures_published)
    else
      album_pictures_published
    end
  end

  ### album_pictures_sort_method

  def album_pictures_sorted
    sorter = album_pictures_sorter
    if sorter
      sorter.call(album_pictures)
    else
      album_pictures
    end
  end

  def album_pictures_sorter
    SorterAlbumPictures.find(album_pictures_sort_method)
  end

  ### artist

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

  #### TODO: no calls?
  def does_have_album_artist
    album_artist.to_s != ''
  end

  def does_have_alt_url
    alt_url.to_s != ''
  end

  def does_have_audio
    audio_count.to_i > 0
  end

  def does_have_audio_published
    audio_published_count.to_i > 0
  end

  def is_newly_built_and_has_unassigned_keyword
    (id == nil) && (joined_keywords.length == 1) && (joined_keywords[0].id == nil)
  end

  def does_have_coverpicture
    coverpicture && coverpicture.picture
  end

  def does_have_description
    description_markup_text.to_s != ''
  end

  def does_have_personnel
    personnel_markup_text.to_s != ''
  end

  def does_have_keywords
    keywords_count.to_i > 0
  end

  #### TODO: no calls?
  def does_have_more_than_one_audio
    audio_count.to_i > 1
  end

  def does_have_more_than_one_picture
    pictures_count.to_i > 1
  end

  def does_have_musicians
    musicians_markup_text.to_s != ''
  end

  def does_have_pictures
    pictures_count.to_i > 0
  end

  def does_have_pictures_published
    pictures_published_count.to_i > 0
  end

  def does_have_pictures_sorter_id
    pictures_sorter_id.to_s != ''
  end

  def does_have_vendor_widget_gumroad
    vendor_widget_gumroad.to_s != ''
  end

  def does_not_have_alt_url
    alt_url.to_s == ''
  end

  def duration(rounded_to: nil)
    case rounded_to
    when :secs, :seconds
      duration_rounded_to_seconds
    when :mils, :milliseconds
      duration_rounded_to_milliseconds
    else
      duration_rounded_to_milliseconds
    end
  end

  def duration_rounded_to_seconds
    mins = 0
    secs = 0
    mils = 0
    audio.each do |a|
      mins += a.duration_mins
      secs += a.duration_secs
      mils += a.duration_mils
    end
    while mils >= 1000
      mils -= 1000
      secs += 1
    end
    if (mils >= 500)
      secs += 1
    end
    while secs >= 60
      secs -= 60
      mins += 1
    end
    "#{mins}:#{secs.to_s.rjust(2, '0')}"
  end

  def duration_rounded_to_milliseconds
    mins = 0
    secs = 0
    mils = 0
    audio.each do |aud|
      mins += aud.duration_mins.to_i
      secs += aud.duration_secs.to_i
      mils += aud.duration_mils.to_i
    end
    while mils >= 1000
      mils -= 1000
      secs += 1
    end
    while secs >= 60
      secs -= 60
      mins += 1
    end
    "#{mins}:#{secs.to_s.rjust(2, '0')}.#{mils.to_s.rjust(3, '0')}"
  end

  ### duration_mins

  ### duration_secs

  ### duration_mils

  ### id

  def id_admin
    friendly_id
  end

  def id_public
    friendly_id
  end

  ### index_can_display_tracklist

  ### index_tracklist_audio_includes_subtitles

  def index_will_display_tracklist
    index_can_display_tracklist && does_have_audio
  end

  def is_joinable?
    ['public_indexable', 'public_joinable'].include?(visibility)
  end

  def is_published?
    is_joinable? && is_released?
  end

  def is_released?
    date_released <= FindPublished.date_today
  end

  def joined_audio
    album_audio
  end

  def joined_audio_sorted
    album_audio_sorted
  end

  def joined_keywords
    album_keywords
  end

  def joined_keywords_sorted
    album_keywords_sorted
  end

  def joined_pictures
    album_pictures
  end

  def joined_pictures_sorted
    album_pictures_sorted
  end

  ### keywords

  ### keywords_count

  def keywords_sorted
    keywords_sorted_by_title_asc
  end

  def keywords_sorted_by_title_asc
    keywords.to_a.sort_by! { |keyword| keyword.title.downcase }
  end

  def linkable
    published || (visibility == 'unlisted')
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

  ### pictures

  ### pictures_count

  def pictures_published_sorted
    album_pictures_published_sorted.map { |ap| ap.picture }
  end

  def pictures_sorted
    album_pictures_sorted.map { |ap| ap.picture }
  end

  def published
    released && (['public','unindexed'].include?(visibility))
  end

  def released
    date_released <= FindPublished.date_today
  end

  def should_generate_new_friendly_id?
    date_released_changed? ||
    title_changed? ||
    super
  end

  ### show_can_cycle_pictures

  ### show_can_have_more_pictures_link

  ### show_can_have_vendor_widget_gumroad

  def show_will_cycle_pictures
    show_can_cycle_pictures && does_have_more_than_one_picture
  end

  def show_will_display_vendor_link
    false
  end

  def show_will_have_more_pictures_link
    show_can_have_more_pictures_link && does_have_more_than_one_picture
  end

  def show_will_have_vendor_widget_gumroad
    show_can_have_vendor_widget_gumroad && does_have_vendor_widget_gumroad
  end

  def show_will_link_to_alt_url
    show_can_link_to_alt_url && does_have_alt_url
  end

  def show_will_not_link_to_alt_url
    show_will_link_to_alt_url != true
  end

  ### slug

  def slug_candidates
    [
      [:title],
      [:title, :year]
    ]
  end

  ### title

  def title_sortable
    title.to_s
  end

  ### updated_at

  ### visibility

  def year
    if date_released
      date_released.year
    else
      nil
    end
  end


  private

  def strip_whitespace_edges_from_entered_text
    strippable_attributes = [
      'album_artist',
      'copyright_markup_text',
      'description_markup_text',
      'musicians_markup_text',
      'personnel_markup_text',
      'title',
      'vendor_widget_gumroad'
    ]
    changed_strippable_attributes = self.changed.select { |v| strippable_attributes.include?(v) }
    changed_strippable_attributes.each do |attribute|
      stripped_value = self.read_attribute(attribute).to_s.strip
      self.write_attribute(attribute, stripped_value)
    end
  end

end
