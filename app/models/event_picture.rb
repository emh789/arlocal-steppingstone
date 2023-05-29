class EventPicture < ApplicationRecord


  belongs_to :event, counter_cache: :pictures_count
  belongs_to :picture, counter_cache: :events_count
  

  ### created_at


  ### event_id


  ### event_order


  ### id


  ### is_coverpicture


  ### picture_id


  ### updated_at


end
