class Article < ApplicationRecord


  extend FriendlyId
  extend MarkupParserUtils
  extend Neighborable
  extend Paginateable
  include Seedable

  scope :publicly_indexable, -> { where(visibility: ['public']) }
  scope :publicly_linkable,  -> { where(visibility: ['public', 'unlisted']) }

  friendly_id :slug_candidates, use: :slugged

  has_many :infopage_items, -> { where infopageable_type: 'Article' }, foreign_key: :infopageable_id, dependent: :destroy
  has_many :infopages, through: :infopage_items


  validates :content_parser_id, presence: true
  validates :copyright_parser_id, presence: true


  public


  ### author


  ### content_parser_id


  def content_props
    { parser_id: content_parser_id, text_markup: content_text_markup }
  end


  ### content_text_markup


  ### copyright_parser_id


  def copyright_props
    { parser_id: copyright_parser_id, text_markup: copyright_text_markup }
  end


  ### copyright_text_markup


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


  def joined_infopages
    infopage_items
  end


  ### parser_id


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
      [:title]
    ]
  end


  ### text_markup


  ### title


  ### updated_at


  ### visibility


end
