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
    },
    {
      id: 'isrc_desc',
      description: 'by isrc (descending)',
    },
    {
      id: 'title_asc',
      description: 'by title (ascending)',
    },
    {
      id: 'title_desc',
      description: 'by title (descending)',
    },
    {
      id: 'class_title_asc',
      description: 'by class, then title (ascending)',
    },
    {
      id: 'class_title_desc',
      description: 'by class, then title (descending)',
    }
  ]


  attr_reader :id, :description


  def initialize(sorter)
    if sorter
      @id = sorter[:id]
      @description = sorter[:description]
      @symbol = sorter[:symbol]
    end
  end


  public


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
