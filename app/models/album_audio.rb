class AlbumAudio < ApplicationRecord

  scope :albums_released,         -> { joins(:albums).where('album.date_released <= ?', FindPublished.date_today) }
  scope :albums_public_joinable,  -> { joins(:albums).where(album: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :albums_published,        -> { albums_public_joinable.albums_released }

  scope :audio_released,        -> { joins(:audio).where('audio.date_released <= ?', FindPublished.date_today) }
  scope :audio_public_joinable, -> { joins(:audio).where(audio: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :audio_published,       -> { audio_public_joinable.audio_released }

  scope :includes_album,    -> { includes(:album) }
  scope :includes_audio,    -> { includes(audio: :source_uploaded_attachment) }

  belongs_to :album, counter_cache: :audio_count
  belongs_to :audio, counter_cache: :albums_count


  public

  ### album_id

  ### album_order

  ### audio_id

  ### created_at

  def title_for_display
    if album.index_tracklist_audio_includes_subtitles
      audio.title_and_subtitle_for_display
    else
      audio.title_for_display
    end
  end

  def does_have_order
    order.to_s.length > 0
  end

  def full_title
    audio.full_title
  end

  ### id

  def order
    album_order
  end

  def playlist_order
    album_order
  end

  def title
    audio_title
  end

  ### updated_at

end
