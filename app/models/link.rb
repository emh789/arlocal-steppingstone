class Link < ApplicationRecord


  extend Neighborable
  include Seedable


  before_validation :strip_whitespace_edges_from_entered_text

  validates :details_markup_type, presence: true

  has_many :infopage_items, -> { where infopageable_type: 'Link' }, foreign_key: :infopageable_id, dependent: :destroy
  has_many :infopages, through: :infopage_items

  accepts_nested_attributes_for :infopage_items, allow_destroy: true




  public



  ### addresss_href


  def address_href_domain
    address_href.split('@')[1]
  end


  def address_href_hashed
    { recipient: address_href_recipient, domain: address_href_domain }
  end


  def address_href_recipient
    address_href.gsub(/\Amailto:/i, '').split('@')[0]
  end


  ### address_inline_text


  def address_props
    {
      address_href: address_href,
      address_inline_text: address_inline_text,
      # address_type: address_type,
      details_markup_type: details_markup_type,
      details_markup_text: details_markup_text,
      name: name,
    }
  end


  ### address_type
  # :email, :web
  # used in app/helpers/link_helper.rb


  def address_type
    if /\Ahttps?:\/\// =~ address_href.to_s
      :web
    elsif /\Amailto:/ =~ address_href.to_s
      :email
    end
  end



  ### created_at


  ### details_markup_type


  def details_props
    { markup_type: details_markup_type, markup_text: details_markup_text }
  end


  ### details_markup_text


  # => ### display_method
  #    # 'name_and_address'
  #    # 'address_only'



  def does_have_address_inline_text
    address_inline_text.to_s != ''
  end


  def does_have_infopages
    infopages.length > 0
  end


  def does_not_have_address_inline_text
    address_inline_text.to_s == ''
  end


  def effective_inline_text
    if does_have_address_inline_text
      address_inline_text
    elsif does_not_have_address_inline_text
      address_href
    end
  end


  ### id


  def id_admin
    id
  end


  def id_public
    id
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


  ### name


  def title
    name
  end


  ### updated_at


  ### visibility
  # def visibility
  #   'unlisted'
  # end


  private


  def strip_whitespace_edges_from_entered_text
    strippable_attributes = [
      'address_href',
      'address_inline_text',
      'details_markup_text',
      'name'
    ]
    changed_strippable_attributes = self.changed.select { |v| strippable_attributes.include?(v) }
    changed_strippable_attributes.each do |a|
      stripped_attribute = self.read_attribute(a).to_s.strip
      self.write_attribute(a, stripped_attribute)
    end
  end


end
