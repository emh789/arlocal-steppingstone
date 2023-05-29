class VideoKeyword < ApplicationRecord


  belongs_to :video, counter_cache: :keywords_count
  belongs_to :keyword, counter_cache: :videos_count


  ### created_at


  def does_have_order
    false
  end


  ### id


  ### keyword_id


  ### updated_at


  ### video_id


end
