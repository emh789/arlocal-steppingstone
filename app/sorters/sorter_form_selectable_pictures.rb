class SorterFormSelectablePictures
  extend InactiveRecordSingleton


  DATA = [
    {
      id: 'all_title_asc',
      description: 'all pictures, by title (ascending)',
      method: Proc.new { |pictures| pictures.sort_by{ |p| p.title_without_markup.downcase } }
    },
    {
      id: 'all_title_desc',
      description: 'all pictures, by title (descending)',
      method: Proc.new { |pictures| pictures.sort_by{ |p| p.title_without_markup.downcase }.reverse }
    },
    {
      id: 'only_match_keywords',
      description: 'only pictures with matching keywords',
      method: Proc.new { |pictures| pictures.joins(:keywords).where(keywords: { id: keywords.map { |k| k.id } }) }
    },
    {
      id: 'only_recent_10',
      description: 'only the most recent 10',
      method: Proc.new { |pictures| pictures.order(:created_at).limit(10).sort_by{ |p| p.title_without_markup.downcase } }
    },
    {
      id: 'only_recent_20',
      description: 'only the most recent 20',
      method: Proc.new { |pictures| pictures.order(:created_at).limit(20).sort_by{ |p| p.title_without_markup.downcase } }
    },
    {
      id: 'only_recent_40',
      description: 'only the most recent 40',
      method: Proc.new { |pictures| pictures.order(:created_at).limit(40).sort_by{ |p| p.title_without_markup.downcase } }
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


  def sort(collection)
    @method.call collection
  end

  
end
