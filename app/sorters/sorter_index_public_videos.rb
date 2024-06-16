class SorterIndexPublicVideos


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
    {
      id: 'datetime_asc',
      description: 'by date released (old - new)',
      method: Proc.new { |videos| videos.sort_by{ |v| v.date_released_sortable } }
    },
    {
      id: 'datetime_desc',
      description: 'by date released (new - old)',
      method: Proc.new { |videos| videos.sort_by{ |v| v.date_released_sortable }.reverse }
    },
    {
      id: 'title_asc',
      description: 'by title (forward)',
      method: Proc.new { |videos| videos.sort_by{ |v| v.title.downcase } }
    },
    {
      id: 'title_desc',
      description: 'by title (reverse)',
      method: Proc.new { |videos| videos.sort_by{ |v| v.title.downcase }.reverse }
    },
    {
      id: 'keyword_title_asc',
      description: 'by keyword, then title (forward)',
      method: Proc.new { |videos| SorterIndexPublicVideos.sort_by_keyword(videos, inner_order: :title_asc) }
    },
    {
      id: 'keyword_datetime_desc',
      description: 'by keyword, then datetime (new - old)',
      method: Proc.new { |videos| SorterIndexPublicVideos.sort_by_keyword(videos, inner_order: :date_released_desc) }
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
      public_videos_path({filter: @id})
    else
      public_videos_path
    end
  end


  protected


  def self.sort_by_keyword(video_collection, inner_order: :title_asc)
    videos_by_keyword = Hash.new

    keyword_collection = Keyword.will_select_published_videos
    keyword_collection.each do |keyword|
      videos_by_keyword[keyword.title] = video_collection.with_keywords_matching(keyword_collection)
    end
    videos_by_keyword["more videos"] = video_collection.without_any_or_matching_keywords(keyword_collection)

    videos_by_keyword.delete_if { |keyword, videos| videos == [] }
    videos_by_keyword.each_pair do |keyword, videos|
      case inner_order
      when :date_released_desc
        videos_by_keyword[keyword] = videos.sort_by{ |video| video.date_released_sortable }.reverse
      when :title_asc
        videos_by_keyword[keyword] = videos.sort_by{ |video| video.title.downcase }
      end
    end

    videos_by_keyword
  end


end
