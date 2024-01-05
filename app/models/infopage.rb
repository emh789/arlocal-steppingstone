class Infopage < ApplicationRecord


  extend FriendlyId
  extend Neighborable

  scope :publicly_indexable, -> { where(visibility: ['public']) }
  scope :publicly_linkable,  -> { where(visibility: ['public', 'unlisted']) }

  friendly_id :slug_candidates, use: :slugged

  has_many :infopage_items, dependent: :destroy
  has_many :items, class_name: 'InfopageItem', dependent: :destroy

  has_many :infopage_articles, -> { where infopageable_type: 'Article' }, class_name: 'InfopageItem', dependent: :destroy
  has_many :infopage_links, -> { where infopageable_type: 'Link' }, class_name: 'InfopageItem', dependent: :destroy
  has_many :infopage_pictures, -> { where infopageable_type: 'Picture' }, class_name: 'InfopageItem', dependent: :destroy

  has_many :articles, through: :infopage_items, source: :infopageable, source_type: 'Article'
  has_many :links, through: :infopage_items, source: :infopageable, source_type: 'Link'
  has_many :pictures, through: :infopage_items, source: :infopageable, source_type: 'Picture'

  accepts_nested_attributes_for :infopage_items, allow_destroy: true
  accepts_nested_attributes_for :infopage_articles, allow_destroy: true
  accepts_nested_attributes_for :infopage_links, allow_destroy: true
  accepts_nested_attributes_for :infopage_pictures, allow_destroy: true, reject_if: proc { |attributes| attributes['picture_id'] == '' }
  accepts_nested_attributes_for :items, allow_destroy: true


  public


  def articles_count
    articles.to_a.length
  end


  def articles_sorted
    articles_sorted_by_title_asc
  end


  def articles_sorted_by_title_asc
    articles.to_a.sort_by! { |article| article.title }
  end


  ### created_at


  def does_have_articles
    articles.any?
  end


  def does_have_links
    links.any?
  end


  def does_have_pictures
    pictures.any?
  end


  def does_have_items
    infopage_items.any?
  end


  def does_have_items_group_bottom
    does_have_items_group_left || does_have_items_group_right
  end


  def does_have_items_group_left
    items_group_left.any?
  end


  def does_have_items_group_right
    items_group_right.any?
  end


  def does_have_items_group_top
    items_group_top.any?
  end


  ### id


  def id_admin
    friendly_id
  end


  def id_public
    friendly_id
  end


  ### info_order


  def infopage_articles_sorted
    infopage_articles
  end


  def infopage_links_sorted
    infopage_links
  end


  def infopage_pictures_sorted
    infopage_pictures
  end


  def infopage_items_sorted
    [ items_group_top_sorted, items_group_left_sorted, items_group_right_sorted ].flatten
  end


  def items_group_left
    infopage_items.to_a.select { |item| item.is_group_left }
  end


  def items_group_left_sorted
    items_group_left.sort_by! { |item| item.infopage_group_order }
  end


  def items_group_right
    infopage_items.to_a.select { |item| item.is_group_right }
  end


  def items_group_right_sorted
    items_group_right.sort_by! { |item| item.infopage_group_order }
  end


  def items_group_top
    infopage_items.select { |item| item.is_group_top }
  end


  def items_group_top_sorted
    items_group_top.sort_by! { |item| item.infopage_group_order }
  end


  def links_count
    links.length
  end


  def links_sorted
    links_sorted_by_title_asc
  end


  def links_sorted_by_title_asc
    links.to_a.sort_by! { |link| link.title }
  end


  def pictures_count
    pictures.length
  end


  def pictures_sorted
    pictures_sorted_by_title_asc
  end


  def pictures_sorted_by_title_asc
    pictures.to_a.sort_by! { |picture| picture.title.downcase }
  end


  def published
    ['public','unlisted'].include?(visibility)
  end


  def should_generate_new_friendly_id?
    title_changed? ||
    super
  end


  ### slug


  def slug_candidates
    [
      [:title],
      [:title, :index_order ]
    ]
  end


  ### :title


  ### updated_at


  ### visibility


end
