class Album < ApplicationRecord


  extend FriendlyId
  extend MarkupParserUtils
  extend Neighborable
  extend Paginateable
  include Seedable

  scope :publicly_indexable, -> { where(visibility: ['public']) }
  scope :publicly_linkable,  -> { where(visibility: ['public', 'unlisted']) }

  friendly_id :slug_candidates, use: :slugged

  before_validation :strip_whitespace_edges_from_entered_text

  validates :album_pictures_sorter_id, presence: true
  validates :description_parser_id,    presence: true
  validates :date_released,            presence: true
  validates :title,                    presence: true

  has_many :album_audio, -> { includes(:audio) }, dependent: :destroy
  has_many :audio, through: :album_audio

  has_many :album_keywords, -> { includes(:keyword) }, dependent: :destroy
  has_many :keywords, through: :album_keywords

  has_many :album_pictures, -> { includes(:picture) }, dependent: :destroy
  has_many :pictures, through: :album_pictures

  has_one :coverpicture, -> { where(is_coverpicture: true).includes(:picture) }, class_name: 'AlbumPicture'

  accepts_nested_attributes_for :album_audio, allow_destroy: true
  accepts_nested_attributes_for :album_keywords, allow_destroy: true, reject_if: proc { |attributes| attributes['keyword_id'] == '0' }
  accepts_nested_attributes_for :album_pictures, allow_destroy: true, reject_if: proc { |attributes| attributes['picture_id'] == '' }
  accepts_nested_attributes_for :audio
  accepts_nested_attributes_for :pictures


  public


  ### album_artist


  ### album_audio


  def album_audio_published_sorted
    album_audio_sorted.select { |aa| aa.audio.published == true }
  end


  def album_audio_sorted
    album_audio_sorted_by_album_order_asc
  end


  def album_audio_sorted_by_album_order_asc
    album_audio.to_a.sort_by! { |aa| aa.album_order }
  end


  def album_keywords_sorted
    album_keywords_sorted_by_title_asc
  end


  def album_keywords_sorted_by_title_asc
    album_keywords.to_a.sort_by! { |ak| ak.keyword.title.downcase }
  end


  def album_pictures_published_sorted
    album_pictures_sorted.select { |ap| ap.picture.published == true }
  end


  def album_pictures_sorted
    if album_pictures_sorter
      album_pictures_sorter.call(album_pictures)
    else
      album_pictures
    end
  end


  def album_pictures_sorter
    SorterAlbumPictures.find(album_pictures_sorter_id)
  end


  ### album_pictures_sorter_id


  ### artist


  ### audio


  ### audio_count


  def audio_published
    audio.select { |a| a.published == true }
  end


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


  ### created_at


  ### date_released


  ### description_parser_id


  def description_props
    { parser_id: description_parser_id, text_markup: description_text_markup }
  end


  ### description_text_markup


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


  def does_have_coverpicture
    coverpicture && coverpicture.picture
  end


  def does_have_description
    description_text_markup.to_s != ''
  end


  def does_have_personnel
    personnel_text_markup.to_s != ''
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
    musicians_text_markup.to_s != ''
  end


  def does_have_pictures
    pictures_count.to_i > 0
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
    "#{mins}:#{secs.to_s.rjust(2, '0')}:#{mils.to_s.rjust(3, '0')}"
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


  ### indexed


  def joined_audio
    album_audio_sorted
  end

  def joined_keywords
    album_keywords_sorted
  end

  def joined_pictures
    album_pictures_sorted
  end


  ### keywords


  ### keywords_count


  ### musicians_parser_id


  def musicians_props
    { parser_id: musicians_parser_id, text_markup: musicians_text_markup }
  end


  ### musicians_text_markup


  ### personnel_parser_id


  def personnel_props
    { parser_id: personnel_parser_id, text_markup: personnel_text_markup }
  end


  ### personnel_text_markup


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
    album_pictures_published_sorted.map { |ap| ap.picture }
  end


  def pictures_sorted
    album_pictures_sorted.map { |ap| ap.picture }
  end


  def published
    ['public','unlisted'].include?(visibility)
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


  def title_downcase
    title.downcase
  end


  def update_and_recount_joined_resources(album_params)
    Album.reset_counters(id, :audio, :pictures, :keywords)
    update(album_params)
  end


  ### updated_at


  ### visibility


  def year
    date_released.year
  end



  private


  def strip_whitespace_edges_from_entered_text
    [ self.album_artist,
      self.copyright_text_markup,
      self.description_text_markup,
      self.musicians_text_markup,
      self.personnel_text_markup,
      self.title,
      self.vendor_widget_gumroad
    ].select{ |a| a.to_s != '' }.each { |a| a.to_s.strip! }
  end


end
