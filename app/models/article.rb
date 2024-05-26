class Article < ApplicationRecord


  extend FriendlyId
  extend Neighborable
  extend Paginateable
  include Seedable

  scope :publicly_indexable, -> { where('visibility = ? AND date_released <= ?', 'public', Date.new(*(Time.now.strftime('%Y %m %d').split(' ').map{ |i| i.to_i })) ) }
  scope :publicly_linkable,  -> { where(visibility: ['public', 'unindexed', 'unlisted']) }

  friendly_id :slug_candidates, use: :slugged

  has_many :infopage_items, -> { where infopageable_type: 'Article' }, foreign_key: :infopageable_id, dependent: :destroy
  has_many :infopages, through: :infopage_items

  before_validation :strip_whitespace_edges_from_entered_text

  validates :content_markup_type, presence: true
  validates :copyright_markup_type, presence: true


  public


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
    infopages.length > 0
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


  def joined_infopages
    infopage_items
  end


  def published
    ['public','unindexed'].include?(visibility)
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
