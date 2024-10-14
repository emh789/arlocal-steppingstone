class VideoPicture < ApplicationRecord

  scope :includes_picture,  -> { includes(:picture) }
  scope :includes_video,    -> { includes(:video) }
  scope :is_coverpicture,   -> { where(is_coverpicture: true) }

  scope :pictures_joinable,   -> { joins(:picture).where(pictures: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :pictures_published,  -> { pictures_joinable }

  scope :videos_joinable,  -> { joins(:video).where(videos: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :videos_released,  -> { joins(:video).where('video.date_released <= ?', FindPublished.date_today) }
  scope :videos_published, -> { videos_joinable.videos_released }

  belongs_to :video, counter_cache: :pictures_count
  belongs_to :picture, counter_cache: :videos_count


  ### created_at

  def does_have_order
    order.to_s.length > 0
  end

  ### id

  ### is_coverpicture

  def order
    video_order
  end

  ### picture_id

  ### updated_at

  ### video_id

  ### video_order

end
