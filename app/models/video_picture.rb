class VideoPicture < ApplicationRecord


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
