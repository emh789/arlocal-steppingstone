class SorterIndexAdminEvents


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
    {
      id: 'datetime_asc',
      description: 'by start time (ascending)',
      method: Proc.new { |events| events.sort_by{ |e| e.datetime_utc } }
    },
    {
      id: 'datetime_desc',
      description: 'by start time (descending)',
      method: Proc.new { |events| events.sort_by{ |e| e.datetime_utc }.reverse }
    },
    {
      id: 'title_asc',
      description: 'by title (ascending)',
      method: Proc.new { |events| events.sort_by{ |e| e.title.downcase } }
    },
    {
      id: 'title_desc',
      description: 'by title (descending)',
      method: Proc.new { |events| events.sort_by{ |e| e.title.downcase }.reverse }
    },
    {
      id: 'only_future',
      description: 'only future',
      method: Proc.new { |events| events.only_future.sort_by{ |e| e.datetime_utc } }
    },
    {
      id: 'only_past',
      description: 'only past',
      method: Proc.new { |events| events.only_past.sort_by{ |e| e.datetime_utc }.reverse }
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
      admin_events_path({filter: @id})
    else
      admin_events_path
    end
  end


end
