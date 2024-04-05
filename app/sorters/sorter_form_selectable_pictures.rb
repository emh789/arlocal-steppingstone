class SorterFormSelectablePictures
  extend InactiveRecordSingleton


  DATA = [
    {
      # id: 0,
      id: 'all_title_asc',
      description: 'all pictures, by title (ascending)',
      symbol: :all_title_asc
    },
    {
      # id: 1,
      id: 'all_title_desc',
      description: 'all pictures, by title (descending)',
      symbol: :all_title_desc
    },
    {
      # id: 2,
      id: 'only_match_keywords',
      description: 'only pictures with matching keywords',
      symbol: :only_match_keywords
    },
    {
      # id: 3,
      id: 'only_recent_10',
      description: 'only the most recent 10',
      symbol: :only_recent_10
    },
    {
      # id: 4,
      id: 'only_recent_20',
      description: 'only the most recent 20',
      symbol: :only_recent_20
    },
    {
      # id: 5,
      id: 'only_recent_40',
      description: 'only the most recent 40',
      symbol: :only_recent_40
    }
  ]


  attr_reader :id, :description, :method, :symbol


  def initialize(sorter)
    if sorter
      @id = sorter[:id]
      @description = sorter[:description]
      @method = sorter[:method]
      @symbol = sorter[:symbol]
    end
  end


end
