class SorterIndexAdminIsrc


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  def self.url_options_for_select_contextual(action: :index)
    case action
    when :edit
      self.all_order_by_description.map { |record| [record.description, record.id, {data: {url: record.url_edit}}] }
    when :index
      self.all_order_by_description.map { |record| [record.description, record.id, {data: {url: record.url_index}}] }
    end
  end


  DATA = [
    {
      id: 'isrc_asc',
      description: 'by isrc (ascending)',
      method: Proc.new { |isrcables| isrcables.sort_by{ |i| i.title.downcase }.sort_by{ |i| i.isrc } }
    },
    {
      id: 'isrc_desc',
      description: 'by isrc (descending)',
      method: Proc.new { |isrcables| isrcables.sort_by{ |i| i.title.downcase }.sort_by{ |i| i.isrc }.reverse }
    },
    {
      id: 'title_asc',
      description: 'by title (ascending)',
      method: Proc.new { |isrcables| isrcables.sort_by{ |i| i.title.downcase } }
    },
    {
      id: 'title_desc',
      description: 'by title (descending)',
      method: Proc.new { |isrcables| isrcables.sort_by{ |i| i.title.downcase }.reverse }
    },
    {
      id: 'class_title_asc',
      description: 'by class, then title (ascending)',
      method: Proc.new { |isrcables| isrcables.sort_by{ |i| i.title.downcase }.sort_by{ |i| i.class.to_s } }
    },
    {
      id: 'class_title_desc',
      description: 'by class, then title (descending)',
      method: Proc.new { |isrcables| isrcables.sort_by{ |i| i.title.downcase }.reverse.sort_by{ |i| i.class.to_s } }
    }
  ]


  attr_reader :id, :description, :method


  def initialize(sorter)
    if sorter
      @id = sorter[:id]
      @description = sorter[:description]
      @method = sorter[:method]
    end
  end


  public


  def sort(collection)
    @method.call collection
  end


  def url_edit
    if @id
      admin_isrc_edit_path({filter: @id})
    else
      admin_isrc_edit_path
    end
  end


  def url_index
    if @id
      admin_isrc_index_path({filter: @id})
    else
      admin_isrc_index_path
    end
  end



end
