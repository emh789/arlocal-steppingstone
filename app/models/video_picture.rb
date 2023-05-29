class VideoPicture < ApplicationRecord


  belongs_to :video, counter_cache: :pictures_count
  belongs_to :picture, counter_cache: :videos_count


  ### created_at


  ### id


  ### picture_id


  ### updated_at


  ### video_id


end
