class VideoKeyword < ApplicationRecord

  scope :videos_released,         -> { joins(:video).where('videos.date_released <= ?', FindPublished.date_today) }
  scope :videos_public_joinable,  -> { joins(:video).where(videos: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :videos_published,        -> { videos_public_joinable.videos_released }

  scope :includes_keyword,  -> { includes(:keyword) }
  scope :includes_video,    -> { includes(:video) }

  belongs_to :video,    counter_cache: :keywords_count
  belongs_to :keyword,  counter_cache: :videos_count
  belongs_to :keyword,  counter_cache: :videos_published_count


  ### created_at

  def does_have_order
    false
  end

  ### id

  ### keyword_id

  ### updated_at

  ### video_id

end
