class MarkupParser
  extend InactiveRecordSingleton

  # TODO: `[:symbol]` is deprecated and will be removed once other InactiveRecord datasets use symbolic id
  DATA = [
    {
      id: 'markdown',
      categories: [:admin, :public],
      description: 'Markdown',
      method_parse: lambda { |text| CommonMarker.render_html(text.to_s) },
      method_sanitize: lambda { |text| ApplicationController.helpers.sanitize(text) },
    },
    {
      id: 'plaintext',
      categories: [:admin, :public],
      description: 'Plain text',
      method_parse: lambda { |text| ApplicationController.helpers.simple_format(text.to_s) },
      method_sanitize: lambda { |text| ApplicationController.helpers.sanitize(text) },
    },
    {
      id: 'string',
      categories: [:admin, :public],
      description: 'Single line',
      method_parse: lambda { |text| text.to_s },
      method_sanitize: lambda { |text| ApplicationController.helpers.sanitize(text) },
    }
  ]


  protected


  def self.html_class_prefix
    'arl_markup_parser'
  end


  def self.parse_sanitize_class(resource_text_props)
    parser = MarkupParser.find(resource_text_props[:markup_type])
    if parser == false
      parser = MarkupParser.find('plaintext')
    end
    { html_class: parser.html_class, sanitized_text: parser.parse_and_sanitize(resource_text_props[:markup_text]) }
  end



  public


  attr_reader :id, :description, :html_class, :method_parse, :method_sanitize


  def initialize(parser)
    if parser
      @id = parser[:id]
      @description = parser[:description]
      @html_class = [MarkupParser.html_class_prefix, parser[:id]].join('_')
      @method_parse = parser[:method_parse]
      @method_sanitize = parser[:method_sanitize]
    end
  end


  def parse(text)
    @method_parse.call(text)
  end


  def parse_and_sanitize(text)
    sanitize(parse(text))
  end


  def sanitize(text)
    @method_sanitize.call(text)
  end



end
