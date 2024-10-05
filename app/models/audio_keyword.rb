class AudioKeyword < ApplicationRecord

  scope :audio_released,        -> { joins(:audio).where('audio.date_released <= ?', FindPublished.date_today) }
  scope :audio_public_joinable, -> { joins(:audio).where(audio: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :audio_published,       -> { audio_public_joinable.audio_released }

  scope :includes_audio,    -> { includes(:audio) }
  scope :includes_keyword,  -> { includes(:keyword) }

  belongs_to :audio, counter_cache: :keywords_count
  belongs_to :keyword, counter_cache: :audio_count
  belongs_to :keyword, counter_cache: :audio_published_count

  # counter_culture :keyword,
  #     column_names: -> { {
  #         Audio.published => :audio_published_count
  #     } }


  ### audio_id

  ### created_at

  def does_have_order
    false
  end

  ### id

  ### keyword_id

  ### updated_at

end
