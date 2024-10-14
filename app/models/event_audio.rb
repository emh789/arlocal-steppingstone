class EventAudio < ApplicationRecord

  scope :audio_released,        -> { joins(:audio).where('audio.date_released <= ?', FindPublished.date_today) }
  scope :audio_public_joinable, -> { joins(:audio).where(audio: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :audio_published,       -> { audio_public_joinable.audio_released }

  scope :events_announced,       -> { joins(:event).all }
  scope :events_public_joinable, -> { joins(:event).where(events: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :events_published,       -> { events_public_joinable.events_announced }

  scope :includes_audio,  -> { includes(audio: :source_uploaded_attachment) }
  scope :includes_event,  -> { includes(:event) }

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

  def title
    audio.title
  end

  ### updated_at

end
