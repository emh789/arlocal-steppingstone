class Admin::WelcomeController < AdminController


  def content_storage
  end


  def icons
  end


  def markup_types
    @form_metadata = FormWelcomeMarkupMetadata.new(pane: params[:pane])
    render 'admin/welcome/markup_index'
  end


  def index
  end


  def release_notes
  end


  def visibility
  end


  def whats_new
  end


end
