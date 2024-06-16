class Stream < ApplicationRecord

  extend FriendlyId
  extend Neighborable
  extend Paginateable

  scope :published,                   -> { all_public_joinable }

  scope :all_public_indexable,  -> { where(visibility: ['public_indexable']) }
  scope :all_public_joinable,   -> { where(visibility: ['public_indexable', 'public_joinable']) }
  scope :all_public_showable,   -> { where(visibility: ['public_indexable', 'public_joinable', 'public_showable']) }

  # scope :any_public_released_indexable,   -> { released.all_public_indexable }
  # scope :any_public_released_joinable,    -> { released.all_public_joinable }
  # scope :any_public_released_or_showable, -> { (Stream.published).or(Stream.only_public_showable) }
  # scope :published,                   -> { any_public_released_joinable }

  scope :only_public_indexable, -> { where(visibility: 'public_indexable') }
  scope :only_public_joinable,  -> { where(visibility: 'public_joinable') }
  scope :only_public_showable,  -> { where(visibility: 'public_showable') }
  scope :only_admin_only,       -> { where(visibility: 'admin_only') }

  friendly_id :slug_candidates, use: :slugged

  before_validation :strip_whitespace_edges_from_entered_text

  validates :title, presence: true, uniqueness: true


  public

  def description_props
    { markup_type: description_markup_type, markup_text: description_markup_text }
  end

  ### description_markup_type

  ### description_markup_text

  ### html_element

  def html_element_conditionally
    if is_published?
      html_element.html_safe
    else
      html_element
    end
  end

  ### id

  def id_admin
    friendly_id
  end

  def id_public
    friendly_id
  end

  def is_joinable?
    ['public_indexable', 'public_joinable'].include?(visibility)
  end

  def is_published?
    is_joinable? && is_released?
  end

  def is_released?
    date_released <= FindPublished.date_today
  end

  def should_generate_new_friendly_id?
    title_changed? ||
    super
  end

  ### slug

  def slug_candidates
    [
      [:title]
    ]
  end

  ### title

  ### visibility


  private

  def strip_whitespace_edges_from_entered_text
    strippable_attributes = [
      'html_element',
      'title'
    ]
    changed_strippable_attributes = self.changed.select { |v| strippable_attributes.include?(v) }
    changed_strippable_attributes.each do |attribute|
      stripped_value = self.read_attribute(attribute).to_s.strip
      self.write_attribute(attribute, stripped_value)
    end
  end

end
