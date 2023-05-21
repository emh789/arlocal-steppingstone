class EventVideo < ApplicationRecord
  
  
  belongs_to :event, counter_cache: :videos_count
  belongs_to :video, counter_cache: :events_count
  
  
end
