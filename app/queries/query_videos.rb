class QueryVideos


  protected


  def self.find_admin(id)
    Video.friendly.find(id)
  end


  def self.find_public(id)
    Video.publicly_linkable.friendly.find(id)
  end


  def self.find_with_keyword(keyword)
    Video.joins(:keywords).where(keywords: {id: keyword.id})
  end


  def self.index_admin(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_admin
  end


  def self.index_public(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_public
  end


  def self.neighborhood_admin(video, arlocal_settings)
    new(arlocal_settings: arlocal_settings).neighborhood_admin(video)
  end


  def self.neighborhood_public(video, arlocal_settings)
    new(arlocal_settings: arlocal_settings).neighborhood_public(video)
  end


  def self.options_for_select_admin
    Video.select(:id, :title).sort_by{ |v| v.title.downcase }
  end



  public


  def initialize(**args)
    @arlocal_settings = args[:arlocal_settings]
    @params = args[:params] ? args[:params] : {}
  end


  def all
    all_videos
  end


  def index_admin
    case determine_filter_method_admin
    when 'datetime_asc'
      all_videos.sort_by{ |v| v.date_released }
    when 'datetime_desc'
      all_videos.sort_by{ |v| v.date_released }.reverse
    when 'title_asc'
      all_videos.sort_by{ |v| v.title.downcase }
    when 'title_desc'
      all_videos.sort_by{ |v| v.title.downcase }.reverse
    else
      all_videos
    end
  end


  def index_public
    case determine_filter_method_public
    when 'datetime_asc'
      all_videos.publicly_indexable.sort_by{ |v| v.date_released }
    when 'datetime_desc'
      all_videos.publicly_indexable.sort_by{ |v| v.date_released }.reverse
    when 'keyword_datetime_desc'
      sort_public_videos_by_keyword(inner_order: :date_released_desc)
    when 'keyword_title_asc'
      sort_public_videos_by_keyword(inner_order: :title_asc)
    when 'title_asc'
      all_videos.publicly_indexable.sort_by{ |v| v.title.downcase }
    when 'title_desc'
      all_videos.publicly_indexable.sort_by{ |v| v.title.downcase }.reverse
    else
      all_videos.publicly_indexable
    end
  end


  def neighborhood_admin(video, distance: 1)
    Video.neighborhood(video, collection: index_admin, distance: distance)
  end


  def neighborhood_public(video, distance: 1)
    Video.neighborhood(video, collection: index_public, distance: distance)
  end


  def sort_public_videos_by_keyword(inner_order: nil)
    public_videos_by_keyword = Hash.new

    keyword_collection = Keyword.only_that_will_select_videos
    video_collection = Video.publicly_indexable.joins(:keywords)
    keyword_collection.each do |keyword|
      public_videos_by_keyword[keyword.title] = video_collection.where(keywords: keyword)
    end

    video_without_keyword_collection = video_collection.reject{ |video| video.keywords.map { |keyword| keyword.can_select_videos }.include?(true) }
    public_videos_by_keyword["more videos"] = video_without_keyword_collection

    public_videos_by_keyword.delete_if { |keyword, videos| videos == [] }
    public_videos_by_keyword.each_pair do |keyword, videos|
      case inner_order
      when :date_released_desc
        public_videos_by_keyword[keyword] = videos.sort_by{ |video| video.date_released }.reverse
      when :title_asc
        public_videos_by_keyword[keyword] = videos.sort_by{ |video| video.title.downcase }
      end
    end

    public_videos_by_keyword
  end


  private


  def all_videos
    Video.includes(:events, :keywords, {pictures: :source_uploaded_attachment})
  end


  def determine_filter_method_admin
    if @params[:filter]
      @params[:filter].downcase
    else
      index_sorter_admin.symbol.to_s.downcase
    end
  end


  def determine_filter_method_public
    if @params[:filter]
      @params[:filter].downcase
    else
      index_sorter_public.symbol.to_s.downcase
    end
  end


  def index_sorter_admin
    SorterIndexAdminVideos.find(@arlocal_settings.admin_index_videos_sorter_id)
  end


  def index_sorter_public
    SorterIndexPublicVideos.find(@arlocal_settings.public_index_videos_sorter_id)
  end


end
