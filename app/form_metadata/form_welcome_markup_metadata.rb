class FormWelcomeMarkupMetadata


  extend FormMetadataUtils


  DATA = {
    overview: {
      navbar: 0,
      partial: 'markup_overview'
    },
    markdown: {
      navbar: 1,
      partial: 'markup_example_markdown',
      selectable: { :@markup_parsers => proc { ArlocalMarkupExamples::MARKUP_EXAMPLES[:markdown] } }
    },
    none: {
      navbar: 1,
      partial: 'markup_example_none',
      selectable: { :@markup_parsers => proc { ArlocalMarkupExamples::MARKUP_EXAMPLES[:none] } }
    },
    simpleformat: {
      navbar: 1,
      partial: 'markup_example_simple_format',
      selectable: { :@markup_parsers => proc { ArlocalMarkupExamples::MARKUP_EXAMPLES[:simple_format] } }
    }
  }


  attr_reader :current_pane, :navbar_categories, :partial_name, :selectables


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
    @selectables = {}
  end


end
