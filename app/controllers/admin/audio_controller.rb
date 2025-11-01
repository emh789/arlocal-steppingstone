class Admin::AudioController < AdminController

  def create
    @audio = AudioBuilder.create(params_audio_permitted, arlocal_settings: @arlocal_settings)
    if @audio.save
      flash[:notice] = 'Audio was successfully created.'
      render 'edit'
    else
      @form_metadata = FormAudioMetadata.new
      flash[:notice] = 'Audio could not be created.'
      flash[:errors] = @audio.errors.attribute_names
      render 'new'
    end
  end

  # Even though a missing source file should not invalidate an Audio object,
  # a missing source file should stop the #create_from_import actions.
  def create_from_import
    @audio = AudioBuilder.create_from_import(params_audio_permitted, arlocal_settings: @arlocal_settings)
    if @audio.errors.include?(:source_imported_file_path)
      flash[:notice] = 'Audio could not be imported.'
      flash[:errors] = @audio.errors.attribute_names
      @audio = AudioBuilder.build_with_defaults_and_conditional_autokeyword(arlocal_settings: @arlocal_settings, audio: @audio)
      @form_metadata = FormAudioMetadata.new
      render 'new_import_single'
      return
    end
    if @audio.save
      flash[:notice] = 'Audio was successfully imported.'
      render 'edit'
    else
      flash[:notice] = 'Audio could not be imported.'
      @form_metadata = FormAudioMetadata.new
      render 'new_inport_single'
    end
  end

  def create_from_import_to_album
    @audio = AudioBuilder.create_from_import_and_join_nested_album(params_audio_permitted, arlocal_settings: @arlocal_settings)
    if @audio.errors.include?(:source_imported_file_path)
      flash[:notice] = 'Audio could not be imported.'
      flash[:errors] = @audio.errors.attribute_names
      @audio = AudioBuilder.build_with_defaults_and_conditional_autokeyword(arlocal_settings: @arlocal_settings, audio: @audio)
      @form_metadata = FormAudioMetadata.new
      render 'new_import_single'
      return
    end
    if @audio.save
      flash[:notice] = 'Audio was successfully imported.'
      render 'edit'
    else
      @albums = QueryAlbums.options_for_select_admin
      flash[:notice] = 'Audio could not be imported.'
      render 'new_import_to_album'
    end
  end

  def create_from_import_to_event
    @audio = AudioBuilder.create_from_import_and_join_nested_event(params_audio_permitted, arlocal_settings: @arlocal_settings)
    if @audio.errors.include?(:source_imported_file_path)
      flash[:notice] = 'Audio could not be imported.'
      flash[:errors] = @audio.errors.attribute_names
      @audio = AudioBuilder.build_with_defaults_and_conditional_autokeyword(arlocal_settings: @arlocal_settings, audio: @audio)
      @form_metadata = FormAudioMetadata.new
      render 'new_import_single'
      return
    end
    if @audio.save
      flash[:notice] = 'Audio was successfully imported.'
      render 'edit'
    else
      @events = QueryEvents.options_for_select_admin
      flash[:notice] = 'Audio could not be imported.'
      render 'new_import_to_event'
    end
  end

  def create_from_upload
    @audio = AudioBuilder.create_from_upload(params_audio_permitted, arlocal_settings: @arlocal_settingss)
    if @audio.save
      flash[:notice] = 'Audio was successfully uploaded.'
      render 'edit'
    else
      flash[:notice] = 'Audio could not be uploaded.'
      render 'new_upload_single'
    end
  end

  def create_from_upload_to_album
    @audio = AudioBuilder.create_from_upload_and_join_nested_album(params_audio_permitted, arlocal_settings: @arlocal_settings)
    if @audio.save
      flash[:notice] = 'Audio was successfully uploaded.'
      render 'edit'
    else
      @albums = QueryAlbums.options_for_select_admin
      flash[:notice] = 'Audio could not be uploaded.'
      render 'new_upload_to_album'
    end
  end

  def create_from_upload_to_event
    @audio = AudioBuilder.create_from_upload_and_join_nested_event(params_audio_permitted)
    if @audio.save
      flash[:notice] = 'Audio was successfully uploaded.'
      render 'edit'
    else
      @events = QueryEvents.options_for_select_admin
      flash[:notice] = 'Audio could not be uploaded.'
      render 'new_upload_to_event'
    end
  end

  def destroy
    @audio = QueryAudio.find_admin(params[:id])
    title = @audio.title_for_display
    @audio.source_uploaded.purge
    @audio.destroy
    flash[:notice] = "Audio #{title} was destroyed."
    redirect_to action: :index
  end

  def edit
    @audio = QueryAudio.find_admin(params[:id])
    @audio_neighbors = QueryAudio.neighborhood_admin(@audio, @arlocal_settings)
    @form_metadata = FormAudioMetadata.new(pane: params[:pane])
  end

  def index
    @audio = QueryAudio.index_admin(@arlocal_settings, params)
  end

  def new
    @audio = AudioBuilder.build_with_defaults_and_conditional_autokeyword(arlocal_settings: @arlocal_settings)
    @form_metadata = FormAudioMetadata.new
  end

  def new_import_menu
  end

  def new_import_single
    @audio = AudioBuilder.build_with_defaults_and_conditional_autokeyword(arlocal_settings: @arlocal_settings)
  end

  def new_import_to_album
    @audio = AudioBuilder.build_with_defaults_and_conditional_autokeyword(arlocal_settings: @arlocal_settings)
    @albums = QueryAlbums.options_for_select_admin
  end

  def new_import_to_event
    @audio = AudioBuilder.build_with_defaults_and_conditional_autokeyword(arlocal_settings: @arlocal_settings)
    @events = QueryEvents.options_for_select_admin
  end

  def new_upload_menu
  end

  def new_upload_single
    @audio = AudioBuilder.build_with_defaults_and_conditional_autokeyword(arlocal_settings: @arlocal_settings)
  end

  def new_upload_to_album
    @audio = AudioBuilder.build_with_defaults_and_conditional_autokeyword(arlocal_settings: @arlocal_settings)
    @albums = QueryAlbums.options_for_select_admin
  end

  def new_upload_to_event
    @audio = AudioBuilder.build_with_defaults_and_conditional_autokeyword(arlocal_settings: @arlocal_settings)
    @events = QueryEvents.options_for_select_admin
  end

  def purge_source_uploaded
    @audio = QueryAudio.find_admin(params[:id])
    @audio.source_uploaded.purge
    flash[:notice] = 'Attachment purged from audio.'
    redirect_to edit_admin_audio_path(@audio.id_admin, pane: :source)
  end

  def refresh_id3
  end

  def show
    @audio = QueryAudio.find_admin(params[:id])
    @audio_neighbors = QueryAudio.neighborhood_admin(@audio, @arlocal_settings)
  end

  def update
    @audio = QueryAudio.find_admin(params[:id])
    @audio.assign_attributes(params_audio_permitted)
    changed = @audio.changed
    if @audio.save
      flash[:notice] = 'Audio was successfully updated.'
      flash[:changed] = changed
      redirect_to edit_admin_audio_path(@audio.id_admin, pane: params[:pane])
    else
      @audio_neighbors = QueryAudio.neighborhood_admin(@audio, @arlocal_settings)
      @form_metadata = FormAudioMetadata.new(pane: params[:pane])
      flash[:notice] = 'Audio could not be updated.'
      flash[:errors] = @audio.errors.attribute_names
      render 'edit'
    end
  end


  private

  def params_audio_permitted
    params.require(:audio).permit(
      :artist,
      :audio_artist,
      :composer,
      :copyright_markup_type,
      :copyright_markup_text,
      :date_released,
      :description_markup_type,
      :description_markup_text,
      :duration_hrs,
      :duration_mins,
      :duration_secs,
      :duration_mils,
      :isrc_country_code,
      :isrc_designation_code,
      :isrc_registrant_code,
      :isrc_year_of_reference,
      :musicians_markup_type,
      :musicians_markup_text,
      :personnel_markup_type,
      :personnel_markup_text,
      :source_imported_file_path,
      :source_type,
      :source_uploaded,
      :source_url,
      :subtitle,
      :title,
      :visibility,
      album_audio_attributes: [
        :id,
        :album_id,
        :album_order,
        :_destroy
      ],
      audio_keywords_attributes: [
        :id,
        :keyword_id,
        :_destroy
      ],
      event_audio_attributes: [
        :id,
        :event_id,
        :event_order,
        :_destroy
      ]
    )
  end

end
