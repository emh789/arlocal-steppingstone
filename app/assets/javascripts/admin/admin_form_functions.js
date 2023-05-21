Arlocal.Admin = {};

Arlocal.Admin.Frontend = {

  // updates the image for an associated picture-select imput
  changeSelectedImage: function(event) {
    console.log('select');
    var selected_index = $(event.target).prop('selectedIndex');
    var imageOptions = $(event.target).children('option');
    var newSelection = $(imageOptions[selected_index]);
    var imgElement = $(event.target).parent().find('.arl_form_data_attr_thumbnail_image');
    var newSrc = newSelection.data('picture-src');
    var nilPictureUrl = /imported\/pictures\/$/;
    $(imgElement).attr('src', newSrc);
    return true;
  },

  toggleCheckBoxOnSpace: function(event) {
    console.log(event);
    if (event.which === 32) {
      event.preventDefault();
      var checkbox_visible = event.target;
      var checkbox_name = $(checkbox_visible).attr('for');
      var selector = '#' + checkbox_name
	    var checkbox_actual = $(checkbox_visible).parent().find(selector);
      switch ($(checkbox_actual).prop('checked')) {
        case true:
          $(checkbox_actual).prop('checked', false);
          break;
        case false:
          $(checkbox_actual).prop('checked', true);
          break;
      }
      return true;
    }
  },

  toggleCoverpictureStatuses: function(event) {
    var this_checkbox = event.target;
    switch ($(this_checkbox).prop('checked')) {
      case true:
        var other_checkboxes = $('.arl_active_checkbox_coverpicture').not(this_checkbox);
        $(other_checkboxes).prop('checked',false);
        $(other_checkboxes).parent().parent().find('.arl_form_resource_picture_order').removeClass('arl_form_data_attr_not_applicable');
        $(this_checkbox).prop('checked',true)
        $(this_checkbox).parent().parent().find('.arl_form_resource_picture_order').addClass('arl_form_data_attr_not_applicable');
        break;
      case false:
        $(this_checkbox).parent().parent().find('.arl_form_resource_picture_order').show();
        break;
    }
    return true;
  }
};

Arlocal.Admin._onReady = function() {
  $('.arl_active_checkbox_coverpicture'            ).change(   function(event) { Arlocal.Admin.Frontend.toggleCoverpictureStatuses(event) } );
  $('.arl_form_data_attr_input_checkbox_visible'   ).keypress( function(event) { Arlocal.Admin.Frontend.toggleCheckBoxOnSpace(event) } );
  $('.arl_form_data_joins_destroy_checkbox_visible').keypress( function(event) { Arlocal.Admin.Frontend.toggleCheckBoxOnSpace(event) } );
  $('.arl_form_data_attr_input_select_picture'     ).change(   function(event) { Arlocal.Admin.Frontend.changeSelectedImage(event) } );
  return true;
};


$(document).on('ready', function() { Arlocal.Admin._onReady() } );
