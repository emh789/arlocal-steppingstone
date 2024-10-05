class PictureKeyword < ApplicationRecord

  scope :includes_keyword, -> { includes(:keyword) }
  scope :includes_picture, -> { includes(:picture) }

  scope :pictures_public_joinable,  -> { joins(:picture).where(pictures: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :pictures_published,        -> { pictures_joinable }

  belongs_to :picture, counter_cache: :keywords_count
  belongs_to :keyword, counter_cache: :pictures_count
  belongs_to :keyword, counter_cache: :pictures_published_count

  ### created_at

  def does_have_order
    false
  end

  ### id

  def is_coverpicture
    false
  end

  ### keyword_id

  ### picture_id

  ### updated_at

end
