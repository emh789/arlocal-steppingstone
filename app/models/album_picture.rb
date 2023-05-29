class AlbumPicture < ApplicationRecord


  belongs_to :album, counter_cache: :pictures_count
  belongs_to :picture, counter_cache: :albums_count


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
