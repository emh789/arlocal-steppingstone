class SorterIndexAdminAudio


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
    {
      id: 'datetime_asc',
      description: 'by date released (old - new)',
      method: Proc.new { |audios| audios.sort_by{ |audio| audio.title.downcase }.sort_by{ |audio| audio.date_released } }
    },
    {
      id: 'datetime_desc',
      description: 'by date released (new - old)',
      method: Proc.new { |audios| audios.sort_by{ |audio| audio.title.downcase }.reverse.sort_by{ |audio| audio.date_released }.reverse }
    },
    {
      id: 'filepath_asc',
      description: 'by filepath (ascending)',
      method: Proc.new { |audios| audios.sort_by{ |audio| audio.source_file_path } }
    },
    {
      id: 'filepath_desc',
      description: 'by filepath (descending)',
      method: Proc.new { |audios| audios.sort_by{ |audio| audio.source_file_path }.reverse }
    },
    {
      id: 'isrc_asc',
      description: 'by isrc (ascending)',
      method: Proc.new { |audios| audios.sort_by{ |audio| audio.isrc } }
    },
    {
      id: 'isrc_desc',
      description: 'by isrc (descending)',
      method: Proc.new { |audios| audios.sort_by{ |audio| audio.isrc }.reverse }
    },
    {
      id: 'title_asc',
      description: 'by title (forward)',
      method: Proc.new { |audios| audios.sort_by{ |audio| audio.title.downcase } }
    },
    {
      id: 'title_desc',
      description: 'by title (reverse)',
      method: Proc.new { |audios| audios.sort_by{ |audio| audio.title.downcase }.reverse }
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
      admin_audio_index_path({filter: @id})
    else
      admin_audio_index_path
    end
  end


end
