class EventPicture < ApplicationRecord

  scope :events_announced,       -> { joins(:event).all }
  scope :events_public_joinable, -> { joins(:event).where(events: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :events_published,       -> { events_public_joinable.events_announced }

  scope :includes_event,      -> { includes(:event) }
  scope :includes_picture,    -> { includes(picture: :source_uploaded_attachment) }
  scope :is_coverpicture,     -> { where(is_coverpicture: true) }

  scope :pictures_public_joinable,  -> { joins(:picture).where(pictures: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :pictures_published,        -> { pictures_public_joinable }

  belongs_to :event, counter_cache: :pictures_count
  belongs_to :event, counter_cache: :pictures_published_count
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
