class QueryIsrc


  protected


  def self.all(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_admin
  end



  public


  def initialize(**args)
    arlocal_settings = args[:arlocal_settings]
    params = args[:params] ? args[:params] : {}
    @sorter_admin = determine_sorter_admin(arlocal_settings, params)
  end


  def index_admin
    if @sorter_admin
      index_admin_sorted
    else
      index_admin_unsorted
    end
  end


  def index_admin_sorted
    @sorter_admin.sort index_admin_unsorted
  end


  def index_admin_unsorted
    all_isrcable
  end



  private


  def all_isrcable
    result = []
    result << Audio.all.map { |a| a }
    result << Video.all.map { |v| v }
    result.flatten
  end


  def determine_sorter_admin(arlocal_settings, params)
    if params[:filter]
      SorterIndexAdminIsrc.find(params[:filter])
    else
      SorterIndexAdminIsrc.find(arlocal_settings.admin_index_isrc_sort_method)
    end
  end


end
