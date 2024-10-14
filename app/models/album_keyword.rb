class AlbumKeyword < ApplicationRecord

  scope :albums_released,         -> { joins(:albums).where('album.date_released <= ?', FindPublished.date_today) }
  scope :albums_public_joinable,  -> { joins(:albums).where(album: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :albums_published,        -> { albums_public_joinable.albums_released }

  scope :includes_album,    -> { includes(:album) }
  scope :includes_keyword,  -> { includes(:keyword) }

  belongs_to :album, counter_cache: :keywords_count
  belongs_to :keyword, counter_cache: :albums_count


  public

  ### album_id

  ### created_at

  def does_have_order
    false
  end

  ### id

  ### keyword_id

  ### updated_at

end
