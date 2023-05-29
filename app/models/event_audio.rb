class EventAudio < ApplicationRecord


  belongs_to :event, counter_cache: :audio_count
  belongs_to :audio, counter_cache: :events_count


  ### audio_id


  ### created_at


  def display_title
    audio.title
  end


  def does_have_order
    order.to_s.length > 0
  end


  ### event_id


  ### event_order


  def full_title
    audio.full_title
  end


  ### id


  def order
    event_order
  end


  def playlist_order
    event_order
  end


  # alias for audio_title
  def title
    audio.title
  end


  ### updated_at


end
