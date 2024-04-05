class SorterIndexPublicVideos


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
    {
      # id: 0,
      id: 'datetime_asc',
      description: 'by release date (old - new)',
      symbol: :datetime_asc
    },
    {
      # id: 1,
      id: 'datetime_desc',
      description: 'by release date (new - old)',
      symbol: :datetime_desc
    },
    {
      # id: 2,
      id: 'title_asc',
      description: 'by title (forward)',
      symbol: :title_asc
    },
    {
      # id: 3,
      id: 'title_desc',
      description: 'by title (reverse)',
      symbol: :title_desc
    },
    {
      # id: 4,
      id: 'keyword_title_asc',
      description: 'by keyword, then title (forward)',
      symbol: :keyword_title_asc
    },
    {
      # id: 5,
      id: 'keyword_datetime_desc',
      description: 'by keyword, then datetime (new - old)',
      symbol: :keyword_datetime_desc
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


  # def url
  #   case @symbol
  #   when :datetime_asc
  #     public_videos_path({filter: 'datetime_asc'})
  #   when :datetime_desc
  #     public_videos_path({filter: 'datetime_desc'})
  #   when :keyword_datetime_desc
  #     public_videos_path({filter: 'keyword_datetime_desc'})
  #   when :keyword_title_asc
  #     public_videos_path({filter: 'keyword_title_asc'})
  #   when :title_asc
  #     public_videos_path({filter: 'title_asc'})
  #   when :title_desc
  #     public_videos_path({filter: 'title_desc'})
  #   else
  #     public_videos_path
  #   end
  # end


  def url
    if @id
      public_videos_path({filter: @id})
    else
      public_videos_path
    end
  end


end
