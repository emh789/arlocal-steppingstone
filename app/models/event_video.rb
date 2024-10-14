class EventVideo < ApplicationRecord

  scope :includes_event, -> { includes(:event) }
  scope :includes_video, -> { includes(:video) }

  scope :videos_released,         -> { joins(:video).where('video.date_released <= ?', FindPublished.date_today) }
  scope :videos_public_joinable,  -> { joins(:video).where(video: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :videos_published,        -> { videos_public_joinable.videos_released }

  belongs_to :event, counter_cache: :videos_count
  belongs_to :video, counter_cache: :events_count

end
