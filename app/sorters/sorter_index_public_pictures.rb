class SorterIndexPublicPictures


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
    {
      id: 'datetime_asc',
      description: 'by date/time cascade (old - new)',
      method: Proc.new { |pictures| pictures.sort_by{ |p| p.datetime_effective_value } }
    },
    {
      id: 'datetime_desc',
      description: 'by date/time cascade (new - old)',
      method: Proc.new { |pictures| pictures.sort_by{ |p| p.datetime_effective_value }.reverse }
    },
    {
      id: 'filepath_asc',
      description: 'by filepath (ascending)',
      method: Proc.new { |pictures| pictures.sort_by{ |p| [p.source_type.to_s, p.source_file_path.to_s] } }
    },
    {
      id: 'filepath_desc',
      description: 'by filepath (descending)',
      method: Proc.new { |pictures| pictures.sort_by{ |p| [p.source_type.to_s, p.source_file_path.to_s] }.reverse }
    },
    {
      id: 'title_asc',
      description: 'by title (ascending)',
      method: Proc.new { |pictures| pictures.sort_by{ |p| p.title_without_markup.downcase } }
    },
    {
      id: 'title_desc',
      description: 'by title (descending)',
      method: Proc.new { |pictures| pictures.sort_by{ |p| p.title_without_markup.downcase }.reverse }
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


  def url
    if @id
      public_pictures_path({filter: @id})
    else
      public_pictures_path
    end
  end

end
