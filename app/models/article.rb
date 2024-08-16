class Article < ApplicationRecord

  extend FriendlyId
  extend Neighborable
  extend Paginateable

  scope :future,    -> { where('date_released >  ?', FindPublished.date_today) }
  scope :published, -> { any_public_released_joinable }
  scope :released,  -> { where('date_released <= ?', FindPublished.date_today) }

  scope :all_public_indexable,  -> { where(visibility: ['public_indexable']) }
  scope :all_public_joinable,   -> { where(visibility: ['public_indexable', 'public_joinable']) }
  scope :all_public_showable,   -> { where(visibility: ['public_indexable', 'public_joinable', 'public_showable']) }

  scope :any_public_released_indexable,   -> { released.all_public_indexable }
  scope :any_public_released_joinable,    -> { released.all_public_joinable }
  scope :any_public_released_or_showable, -> { (Article.published).or(Article.only_public_showable) }

  scope :only_public_indexable, -> { where(visibility: 'public_indexable') }
  scope :only_public_joinable,  -> { where(visibility: 'public_joinable') }
  scope :only_public_showable,  -> { where(visibility: 'public_showable') }
  scope :only_admin_only,       -> { where(visibility: 'admin_only') }

  friendly_id :slug_candidates, use: :slugged

  has_many :infopage_items, -> { infopage_articles.includes_infopage }, foreign_key: :infopageable_id, dependent: :destroy
  has_many :infopages, through: :infopage_items

  before_validation :strip_whitespace_edges_from_entered_text

  validates :content_markup_type, presence: true
  validates :copyright_markup_type, presence: true


  public

  ### article_keywords

  def article_keywords_sorted
    article_keywords_sorted_by_title_asc
  end

  def article_keywords_sorted_by_title_asc
    article_keywords.sort_by! { |ak| ak.keyword.title_sortable.downcase }
  end

  ### author

  def content_beginning_props
    { markup_type: content_markup_type, markup_text: content_markup_text[0..250].gsub(/[\n\r]+/,' ').concat('…') }
  end

  ### content_markup_type

  def content_props
    { markup_type: content_markup_type, markup_text: content_markup_text }
  end

  ### content_markup_text

  ### copyright_markup_type

  def copyright_props
    { markup_type: copyright_markup_type, markup_text: copyright_markup_text }
  end

  ### copyright_markup_text

  ### created_at

  ### date_released

  def does_have_infopages
    infopages_count.to_i > 0
  end

  def does_have_keywords
    keywords_count.to_i > 0
  end

  ### id

  def id_admin
    friendly_id
  end

  def id_public
    friendly_id
  end

  def infopages_sorted
    infopages_sorted_by_order
  end

  def infopages_sorted_by_order
    infopages.to_a.sort_by! { |i| i.index_order }
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

  def joined_infopages
    infopage_items
  end

  def joined_keywords
    article_keywords_sorted
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

  ### updated_at

  ### visibility


  private

  def strip_whitespace_edges_from_entered_text
    strippable_attributes = [
      'author',
      'content_markup_text',
      'copyright_markup_text',
      'title',
    ]
    changed_strippable_attributes = self.changed.select { |v| strippable_attributes.include?(v) }
    changed_strippable_attributes.each do |attribute|
      stripped_value = self.read_attribute(attribute).to_s.strip
      self.write_attribute(attribute, stripped_value)
    end
  end

end
