class SorterIndexPublicAudio


  extend InactiveRecordSingleton
  include Rails.application.routes.url_helpers


  DATA = [
    {
      id: 'filepath_asc',
      description: 'by filepath (ascending)',
      method: Proc.new { |audio| audio.sort_by{ |a| a.source_file_path } }
    },
    {
      id: 'filepath_desc',
      description: 'by filepath (descending)',
      method: Proc.new { |audio| audio.sort_by{ |a| a.source_file_path }.reverse }
    },
    {
      id: 'title_asc',
      description: 'by title (forward)',
      method: Proc.new { |audio| audio.sort_by{ |a| a.title.downcase } }
    },
    {
      id: 'title_desc',
      description: 'by title (reverse)',
      method: Proc.new { |audio| audio.sort_by{ |a| a.title.downcase }.reverse }
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
      public_audio_index_path({filter: @id})
    else
      public_audio_index_path
    end
  end


end
