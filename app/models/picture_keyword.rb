class PictureKeyword < ApplicationRecord


  belongs_to :picture, counter_cache: :keywords_count
  belongs_to :keyword, counter_cache: :pictures_count


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
