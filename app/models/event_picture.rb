class EventPicture < ApplicationRecord


  belongs_to :event, counter_cache: :pictures_count
  belongs_to :picture, counter_cache: :events_count


  ### created_at


  def does_have_order
    order.to_s.length > 0
  end


  ### event_id


  ### event_order


  ### id


  ### is_coverpicture


  def order
    event_order
  end
  

  ### picture_id


  ### updated_at


end
