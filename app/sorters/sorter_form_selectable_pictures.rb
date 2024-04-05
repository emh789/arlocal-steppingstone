class SorterFormSelectablePictures
  extend InactiveRecordSingleton


  DATA = [
    {
      id: 'all_title_asc',
      description: 'all pictures, by title (ascending)',
    },
    {
      id: 'all_title_desc',
      description: 'all pictures, by title (descending)',
    },
    {
      id: 'only_match_keywords',
      description: 'only pictures with matching keywords',
    },
    {
      id: 'only_recent_10',
      description: 'only the most recent 10',
    },
    {
      id: 'only_recent_20',
      description: 'only the most recent 20',
    },
    {
      id: 'only_recent_40',
      description: 'only the most recent 40',
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


end
