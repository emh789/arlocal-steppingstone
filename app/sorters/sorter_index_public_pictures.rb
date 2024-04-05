class SorterIndexPublicPictures


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
    {
      id: 'datetime_asc',
      description: 'by date/time cascade (old - new)',
    },
    {
      id: 'datetime_desc',
      description: 'by date/time cascade (new - old)',
    },
    {
      id: 'filepath_asc',
      description: 'by filepath (ascending)',
    },
    {
      id: 'filepath_desc',
      description: 'by filepath (descending)',
    },
    {
      id: 'title_asc',
      description: 'by title (ascending)',
    },
    {
      id: 'title_desc',
      description: 'by title (descending)',
    }
  ]


  attr_reader :id, :description


  def initialize(sorter)
    if sorter
      @id = sorter[:id]
      @description = sorter[:description]
    end
  end


  public


  def url
    if @id
      public_pictures_path({filter: @id})
    else
      public_pictures_path
    end
  end

end
