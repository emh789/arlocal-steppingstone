class AlbumPicture < ApplicationRecord

  scope :albums_released,         -> { joins(:albums).where('album.date_released <= ?', FindPublished.date_today) }
  scope :albums_public_joinable,  -> { joins(:albums).where(album: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :albums_published,        -> { albums_public_joinable.albums_released }

  scope :includes_album,    -> { includes(:album) }
  scope :includes_picture,  -> { includes(picture: :source_uploaded_attachment) }
  scope :is_coverpicture,   -> { where(is_coverpicture: true) }

  scope :pictures_public_joinable,  -> { joins(:picture).where(pictures: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :pictures_published,        -> { pictures_public_joinable }

  belongs_to :album, counter_cache: :pictures_count
  belongs_to :picture, counter_cache: :albums_count


  public

  ### album_id

  ### created_at

  def does_have_order
    order.to_s.length > 0
  end

  ### id

  ### is_coverpicture

  def order
    album_order
  end

  ### picture_id

  ### updated_at

end
