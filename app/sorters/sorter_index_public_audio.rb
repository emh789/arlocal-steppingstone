class SorterIndexPublicAudio


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
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
      description: 'by title (forward)',
    },
    {
      id: 'title_desc',
      description: 'by title (reverse)',
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


  def url
    if @id
      public_audio_index_path({filter: @id})
    else
      public_audio_index_path
    end
  end


end
