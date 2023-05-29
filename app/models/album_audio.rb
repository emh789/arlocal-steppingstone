class AlbumAudio < ApplicationRecord


  belongs_to :album, counter_cache: :audio_count
  belongs_to :audio, counter_cache: :albums_count


  ### album_id


  ### album_order


  ### audio_id


  ### created_at


  def display_title
    if album.index_tracklist_audio_includes_subtitles
      audio.full_title
    else
      audio.title
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
