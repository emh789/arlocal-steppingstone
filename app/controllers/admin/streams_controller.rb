class Admin::StreamsController < AdminController

  def create
    @stream = StreamBuilder.create(params_stream_permitted)
    if @stream.save
      flash[:notice] = 'Stream was successfully created.'
      redirect_to edit_admin_stream_path(@stream.id_admin)
    else
      @form_metadata = FormStreamMetadata.new(pane: params[:pane])
      flash[:notice] = 'Stream could not be created.'
      render 'new'
    end
  end

  def destroy
    @stream = QueryStreams.find_admin(params[:id])
    @stream.destroy
    flash[:notice] = 'Stream was destroyed.'
    redirect_to action: :index
  end

  def edit
    @stream = QueryStreams.find_admin(params[:id])
    @form_metadata = FormStreamMetadata.new(pane: params[:pane])
  end

  def index
    @streams = QueryStreams.index_admin
  end

  def new
    @stream = StreamBuilder.build_with_defaults
    @form_metadata = FormStreamMetadata.new(pane: params[:pane])
  end

  def show
    @stream = QueryStreams.find_admin(params[:id])
  end

  def update
    @stream = QueryStreams.find_admin(params[:id])
    if @stream.update(params_stream_permitted)
      flash[:notice] = 'Stream was successfuly updated.'
      redirect_to edit_admin_stream_path(@stream.id_admin, pane: params[:pane])
    else
      @form_metadata = FormStreamMetadata.new(pane: params[:pane])
      flash[:notice] = 'Info Page could not be updated.'
      render 'edit'
    end
  end


  private

  def params_stream_permitted
    params.require(:stream).permit(
      :description_markup_type,
      :description_markup_text,
      :html_element,
      :title,
      :visibility
    )
  end

end
