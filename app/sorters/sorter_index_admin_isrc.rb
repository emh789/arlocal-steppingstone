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
      # id: 0,
      id: 'isrc_asc',
      description: 'by isrc (ascending)',
      symbol: :isrc_asc
    },
    {
      # id: 1,
      id: 'isrc_desc',
      description: 'by isrc (descending)',
      symbol: :isrc_desc
    },
    {
      # id: 2,
      id: 'title_asc',
      description: 'by title (ascending)',
      symbol: :title_asc
    },
    {
      # id: 3,
      id: 'title_desc',
      description: 'by title (descending)',
      symbol: :title_desc
    },
    {
      # id: 4,
      id: 'class_title_asc',
      description: 'by class, then title (ascending)',
      symbol: :class_title_asc
    },
    {
      # id: 5,
      id: 'class_title_desc',
      description: 'by class, then title (descending)',
      symbol: :class_title_desc
    }
  ]


  attr_reader :id, :description, :symbol


  def initialize(sorter)
    if sorter
      @id = sorter[:id]
      @description = sorter[:description]
      @symbol = sorter[:symbol]
    end
  end


  public


  # def url_edit
  #   case @symbol
  #   when :class_title_asc
  #     admin_isrc_edit_path({filter: 'class_title_asc'})
  #   when :class_title_desc
  #     admin_isrc_edit_path({filter: 'class_title_desc'})
  #   when :isrc_asc
  #     admin_isrc_edit_path({filter: 'isrc_asc'})
  #   when :isrc_desc
  #     admin_isrc_edit_path({filter: 'isrc_desc'})
  #   when :title_asc
  #     admin_isrc_edit_path({filter: 'title_asc'})
  #   when :title_desc
  #     admin_isrc_edit_path({filter: 'title_desc'})
  #   else
  #     admin_isrc_edit_path
  #   end
  # end


  def url_edit
    if @id
      admin_isrc_edit_path({filter: @id})
    else
      admin_isrc_edit_path
    end
  end


  # def url_index
  #   case @symbol
  #   when :class_title_asc
  #     admin_isrc_index_path({filter: 'class_title_asc'})
  #   when :class_title_desc
  #     admin_isrc_index_path({filter: 'class_title_desc'})
  #   when :isrc_asc
  #     admin_isrc_index_path({filter: 'isrc_asc'})
  #   when :isrc_desc
  #     admin_isrc_index_path({filter: 'isrc_desc'})
  #   when :title_asc
  #     admin_isrc_index_path({filter: 'title_asc'})
  #   when :title_desc
  #     admin_isrc_index_path({filter: 'title_desc'})
  #   else
  #     admin_isrc_index_path
  #   end
  # end


  def url_index
    if @id
      admin_isrc_index_path({filter: @id})
    else
      admin_isrc_index_path
    end
  end



end
