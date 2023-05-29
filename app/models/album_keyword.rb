class AlbumKeyword < ApplicationRecord


  belongs_to :album, counter_cache: :keywords_count
  belongs_to :keyword, counter_cache: :albums_count


  ### album_id


  ### created_at


  def does_have_order
    false
  end


  ### id


  ### keyword_id


  ### updated_at


end
