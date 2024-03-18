class FormWelcomeMarkupMetadata


  extend FormMetadataUtils


  DATA = {
    overview: {
      navbar: 0,
      partial: 'markup_overview'
    },
    'markdown': {
      navbar: 1,
      partial: 'markup_example_markdown',
      markup_examples: proc { ArlocalMarkupExamples::examples },
      parser: proc { MarkupParser.find_by_symbol(:markdown) }
    },
    'plain text': {
      navbar: 1,
      partial: 'markup_example_plain_text',
      markup_examples: proc { ArlocalMarkupExamples::examples },
      parser: proc { MarkupParser.find_by_symbol(:plaintext) }
    },
    'single line': {
      navbar: 1,
      partial: 'markup_example_single_line',
      markup_examples: proc { ArlocalMarkupExamples::examples },
      parser: proc { MarkupParser.find_by_symbol(:string) }
    },
  }


  attr_reader :current_pane, :navbar_categories, :partial_name, :markup_examples, :parser


  def initialize(pane: :overview)
    pane = pane.to_s.downcase.to_sym

    if FormWelcomeMarkupMetadata::DATA.has_key?(pane)
      form = FormWelcomeMarkupMetadata::DATA[pane]
      current_pane = pane
    else
      form = FormWelcomeMarkupMetadata::DATA[:overview]
      current_pane = :overview
    end

    @current_pane = current_pane
    @navbar_categories = FormWelcomeMarkupMetadata.navbar_categories
    @partial_name = form[:partial]
    if form.has_key?(:markup_examples)
      @markup_examples = form[:markup_examples].call
    end
    if form.has_key?(:parser)
      @parser = form[:parser].call
    end
  end


end
