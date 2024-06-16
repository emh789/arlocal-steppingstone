class EventKeyword < ApplicationRecord

  scope :includes_event,    -> { includes(:event) }
  scope :includes_keyword,  -> { includes(:keyword) }

  belongs_to :event, counter_cache: :keywords_count
  belongs_to :keyword, counter_cache: :events_count


  ### created_at

  ### event_id

  ### id

  ### keyword_id

  ### updated_at

end
