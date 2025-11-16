class Admin::AlbumsController < AdminController

  before_action :verify_nested_audio_file_exists,   only: [ :audio_create_from_import ]
  before_action :verify_nested_picture_file_exists, only: [ :picture_create_from_import ]

  def audio_create_from_import
    @album = QueryAlbums.find_admin(params[:id])
    @audio = AudioBuilder.create_from_import_nested_within_album(@album, params_album_permitted, arlocal_settings: @arlocal_settings)
    if @audio.save
      flash[:notice] = 'Audio was successfully imported.'
      redirect_to edit_admin_album_path(@album.id_admin, pane: :audio)
    else
      @form_metadata = FormAlbumMetadata.new(pane: :audio_import, arlocal_settings: @arlocal_settings)
      flash[:notice] = 'Audio could not be imported.'
      render 'edit'
    end
  end

  def audio_create_from_upload
    @album = QueryAlbums.find_admin(params[:id])
    @audio = AudioBuilder.create_from_upload_nested_within_album(@album, params_album_permitted, arlocal_settings: @arlocal_settings)
    if @audio.save
      flash[:notice] = 'Audio was successfully uploaded.'
      redirect_to edit_admin_album_path(@album.id_admin, pane: :audio)
    else
      @form_metadata = FormAlbumMetadata.new(pane: :audio_import, arlocal_settings: @arlocal_settings)
      flash[:notice] = 'Audio could not be uploaded.'
      render 'edit'
    end
  end

  def audio_join_by_keyword
    @keyword = QueryKeywords.find(params[:album][:keywords])
    @album = QueryAlbums.find_admin(params[:id])
    @album.audio << QueryAudio.find_admin_with_keyword(@keyword)
    flash[:notice] = 'Album was successfully updated.'
    redirect_to edit_admin_album_path(@album, pane: params[:pane])
  end

  def create
    @album = AlbumBuilder.create(params_album_permitted, arlocal_settings: @arlocal_settings)
    if @album.save
      flash[:notice] = 'Album was successfully created.'
      redirect_to edit_admin_album_path(@album.id_admin)
    else
      @form_metadata = FormAlbumMetadata.new(pane: params[:pane], arlocal_settings: @arlocal_settings)
      flash[:notice] = 'Album could not be created.'
      render 'new'
    end
  end

  def destroy
    @album = QueryAlbums.find_admin(params[:id])
    @album.destroy
    flash[:notice] = 'Album was destroyed.'
    redirect_to action: :index
  end

  def edit
    @album = QueryAlbums.find_admin(params[:id])
    @album_neighbors = QueryAlbums.neighborhood_admin(@album, @arlocal_settings)
    @form_metadata = FormAlbumMetadata.new(pane: params[:pane], arlocal_settings: @arlocal_settings)
  end

  def index
    @albums = QueryAlbums.index_admin(@arlocal_settings, params)
  end

  def new
    @album = AlbumBuilder.build_with_defaults_and_conditional_autokeyword(arlocal_settings: @arlocal_settings)
    @form_metadata = FormAlbumMetadata.new(pane: params[:pane], arlocal_settings: @arlocal_settings)
  end

  def picture_create_from_import
    @album = QueryAlbums.find_admin(params[:id])
    @picture = PictureBuilder.create_from_import_nested_within_album(@album, params_album_permitted)
    if @picture.save
      flash[:notice] = 'Picture was successfully imported.'
      redirect_to edit_admin_album_path(@album.id_admin, pane: :pictures)
    else
      @form_metadata = FormAlbumMetadata.new(pane: :picture_import, arlocal_settings: @arlocal_settings)
      flash[:notice] = 'Picture could not be imported.'
      render 'edit'
    end
  end

  def picture_create_from_upload
    @album = QueryAlbums.find_admin(params[:id])
    @picture = PictureBuilder.create_from_upload_nested_within_album(@album, params_album_permitted)
    if @picture.save
      flash[:notice] = 'Picture was successfully uploaded.'
      redirect_to edit_admin_album_path(@album.id_admin, pane: :pictures)
    else
      @form_metadata = FormAlbumMetadata.new(pane: :picture_import, arlocal_settings: @arlocal_settings)
      flash[:notice] = 'Picture could not be uploaded.'
      render 'edit'
    end
  end

  def pictures_join_by_keyword
    @keyword = QueryKeywords.find(params[:album][:keywords])
    @album = QueryAlbums.find_admin(params[:id])
    @album.pictures << QueryPictures.find_admin_with_keyword(@keyword)
    flash[:notice] = 'Album was successfully updated.'
    redirect_to edit_admin_album_path(@album, pane: params[:pane])
  end

  def show
    @album = QueryAlbums.find_admin(params[:id])
    @album_neighbors = QueryAlbums.neighborhood_admin(@album, @arlocal_settings)
  end

  def update
    @album = QueryAlbums.find_admin(params[:id])
    if @album.update(params_album_permitted)
      flash[:notice] = 'Album was successfully updated.'
      redirect_to edit_admin_album_path(@album.id_admin, pane: params[:pane])
    else
      @form_metadata = FormAlbumMetadata.new(pane: params[:pane], arlocal_settings: @arlocal_settings)
      flash[:notice] = 'Album could not be updated.'
      render 'edit'
    end
  end


  private

  def params_album_permitted
    params.require(:album).permit(
      :album_artist,
      :album_pictures_sort_method,
      :artist,
      :copyright_markup_type,
      :copyright_markup_text,
      :credits_markup_type,
      :date_released,
      :description_markup_type,
      :description_markup_text,
      :index_can_display_tracklist,
      :musicians_markup_type,
      :musicians_markup_text,
      :personnel_markup_type,
      :personnel_markup_text,
      :show_can_cycle_pictures,
      :show_can_have_more_pictures_link,
      :show_can_have_vendor_widget_gumroad,
      :title,
      :vendor_widget_gumroad,
      :visibility,
      album_audio_attributes: [
        :album_order,
        :audio_id,
        :id,
        :_destroy
      ],
      album_pictures_attributes: [
        :album_order,
        :id,
        :is_coverpicture,
        :picture_id,
        :_destroy
      ],
      album_keywords_attributes: [
        :id,
        :keyword_id,
        :_destroy
      ],
      audio_attributes: [
        :source_uploaded,
        :source_imported_file_path
      ],
      pictures_attributes: [
        :source_uploaded,
        :source_imported_file_path
      ]
    )
  end

  def verify_file(filename)
    if File.exist?(filename) == false
      flash[:notice] = "File not found: #{filename}"
      redirect_to request.referrer
    end
  end

  def verify_nested_audio_file_exists
    filename = helpers.source_imported_file_path(params_album_permitted['audio_attributes']['0']['source_imported_file_path'])
    verify_file(filename)
  end

  def verify_nested_picture_file_exists
    filename = helpers.source_imported_file_path(params_album_permitted['pictures_attributes']['0']['source_imported_file_path'])
    verify_file(filename)
  end

end
