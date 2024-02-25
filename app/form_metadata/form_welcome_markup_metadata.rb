class FormWelcomeMarkupMetadata


  extend FormMetadataUtils


  DATA = {
    markdown: {
      navbar: 1,
      partial: 'markdown',
      selectable: { :@markup_parsers => proc { MarkupParser.options_for_select } }
    },
    none: {
      navbar: 1,
      partial: 'none',
      selectable: { :@markup_parsers => proc { MarkupParser.options_for_select } }
    },
    simpleformat: {
      navbar: 1,
      partial: 'simpleformat',
      selectable: { :@markup_parsers => proc { MarkupParser.options_for_select } }
    }
  }


  attr_reader :current_pane, :navbar_categories, :partial_name, :selectables


  def initialize(pane: :simpleformat)
    pane = pane.to_s.downcase.to_sym

    if FormWelcomeMarkupMetadata::DATA.has_key?(pane)
      form = FormWelcomeMarkupMetadata::DATA[pane]
      current_pane = pane
    else
      form = FormWelcomeMarkupMetadata::DATA[:simpleformat]
      current_pane = :simpleformat
    end

    @current_pane = current_pane
    @navbar_categories = FormWelcomeMarkupMetadata.navbar_categories
    @partial_name = form[:partial]
    @selectables = FormWelcomeMarkupMetadata.new(form[:selectable], arlocal_settings)
  end


end
