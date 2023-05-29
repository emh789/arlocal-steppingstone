class AudioKeyword < ApplicationRecord


  belongs_to :audio, counter_cache: :keywords_count
  belongs_to :keyword, counter_cache: :audio_count


  ### audio_id


  ### created_at


  def does_have_order
    false
  end


  ### id


  ### keyword_id


  ### updated_at


end
