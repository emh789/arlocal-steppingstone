# A&R.Local To-Do List


## HIGHEST priority

migrations:
  - {}_parser_id => {}_parser_type
    - MarkupParser makes more sense with simplified symbols than with numeric id
      - markdown
      - plain text
      - single line
  - link
    - add_column :visibility, 'unlisted'

finish admin renovation
  - `admin/isrc/edit` narrow view buttons overflow right

  - *Review helper methods for currency in light of recent refactoring frenzy.*
    - `resource_admin_title_link` vs `resource_reference_admin_link`

  - Keyword Admin:
    - #edit?videos missing buttons
      - **Finish implementation of video joins submenus; look across resources; also within video#edit**
    - joined pictures lack 'remove' box


## HIGH priority

**- Video player layout could be improved at narrow widths.**
***- Audio player has not been updated in 10 yrs. Can videojs replace it?***

- Link.name should be Link.title for consistency. _wait to look for add'l migrations, do all together_
  - **But `#name` is the name of the destination, not the title of the link.**
  - _Visited this topic before, and kept name._
  - Create semantic sugar method if needed.
- Links_helpers need some review for currency and effectiveness
  - first glance looks okay, but seems overly complicated


- datetime to text inputs instead of selects (why? I forget.) _To avoid over/under parametizing._ Maybe just the year field? The others are fixed and cyclical.
- why does `size: ` attribute result in larger-than-size fields? inherited from CSS maybe?
  - for example `admin/isrc/edit` overflows at narrow widths.


- check various `form_pictures`
  - coverpicture=true would slightly obscure the Order field
  - is a javascript thing.
  - also maybe `form_elements/join_picture_order` needs a class declaration
  - _quickly becomes a tangential UI/UX issue: reimagining the admin UI_
  - _also begs the question, keep using .is_coverpicture boolean, or use first picture by .{resource]_order?_
    - ***YES this is crucial attribute when automatically sorting by time or filename***
    - Depends on video_pictures decision. keep it simple, keep it similar.
    - probably best as a boolean

- Video: include attribute for duration? read mediainfo?

- form_elements/picture_select: should it receive selectable or selectable.pictures?
  - _Check this throughout. Might be best to start with seeing what variables each form_elements requires._

- pictures_helper picture_preferred_url
  - check if picture exists (add file_exists? method to model)
  - if not, return a dummy html_class to guarantee minimal dimensions
- form_pictures exerwhere
- picture_selector in join_single



## Medium priority

- Admin::Articles#index: `content` section might get extremely vertical. Maybe add overflow-y and max-height?

- Articles, Links, and Pictures lack a pane for infopages.

- Should html_head title elements include the resource type? Would help add clarity to browser history.
  - examples:
    - picture: album cover
    - album: Diamonds in the Ruff
  - see Picture for code

autokeyword smells bad.
_Could be replaced by `Add [resource] to Keyword`_

Had AudioHelper.audio_read_source_metadata been refactored into a builder method? *no* If not, should it be? *no, if anywhere then into the Album model*
  - used in `app/views/admin/audio/_form_id3.haml`
- admin:audio#edit?id3 needs some refinement.
  - columns
  - is audio_helper the best place for the method?

- import/upload video via `keywords/_form_video_import`

- change the Calendar model from a module to a class
  - **Compare with video_group.** Maybe it's best as a query method?

+ Note where the selectable value source_type comes from the model, not via FormMetadata::Selectable
  - ***Refactoring these has low priority because there is only one @selectable item.***
    - Controllers::Admin::Audio#new_[method_to_resource]
    - Controllers::Admin::Picture#new_[method_to_resource]
  - ***Refactoring these requires deciding whether to assign SorterIndexAdmin[].options_for_select to @selectable into the controller and passing it all the way through.***
    - Helpers::AudioHelper#audio_admin_filter_select
    - Helpers::EventsHelper#event_public_filter_select
    - Helpers::PicturesHelper#picture_admin_filter_select

+ Albums#Show: section/div nesting doesn't make sense. **CSS Grid will fix this**



## Low Priority

- administrators/sign_in
  - Is it worth getting `devise::rememberable` to work correctly?

- Audio index

- about_arlocal
  - formatting for markup types, esp. for narrow width

**Continue to be mindful about including `autocomplete: false` in form elements.**



## Possibly finished

- `admin/welcome/markup_types` needs dynamic layout. grid fixes this. _no it doesn't_
  - **Might need a rewrite with a `param` and `<select>`**
  - panes: summary, simpleformat, markdown, none
  - _Grid layout fixes many of the other welcome content pages._

- give a title to nested_picture uploads/imports

- check attribute callbacks, add if_changed clause

- admin/pictures#index needs visibility indicator

- eventshelper:158 why assign js empty?

`QueryVideos.sort_public_videos_by_keyword` seems like logic could be refactored into a few different places.
  - Maybe not. It's a specific collection.
  - Makes more sense with improved label semantics.

I think the only test use cases are complete:
Migration for "catalog/imported" and "attachment/uploaded"
  - update the data
    - audio
    - picture
    - arlocal_settings icon_source_type
  - 20230521021626_source_catalog_source_uploaded.rb
    - see 20230405010631_resource_visibility.rb for example
  - **OK now I think.**
  - *Not yet. Somehow the visibility value bleeds into source_type*
  - ***REALLY FREAKING WEIRD.***
    - Migrations can run separately, but in a single roll they mess with data values.

Investigate which `Class.options_for_select_admin` could be optimized with a `.select` or `.pluck` to get only the needed fields for a form select element

video#show css
  text_data, does it need a min-width?
Video index needs headings


## Probably finished

finish admin renovation:
  - TEST EVERY ACTION. LOTS OF CODE GOT RENAMED.
    - live trials suggest this is complete.
  - `admin/#{resource}/edit` category panes have crazy border
  - admin pages: html subtitle could benefit from including resource class ("editing album @album.title")


- admin display review
  - refactor index_joined_resource view templates
    fallout: keyword_statement_items_count methods might be unused now
    (replaced by resource_statement_items_count)
    - looks like it from Album and Picture helpers
    - in `_form_[resource]`

_Looks related to migrations; keep as a reminder_
Renaming source_imported etc resulted in a naming collision
  - resource_model: audio.source_imported_file_path for relative to public/portfolio
  - source_imported_helper: source_imported_file_path(audio) for absolute path to look for file
because Audio.file_exists? is dependent on both the source type and the config.x.arlocal configuration setting for public/portfolio

jplayer_playlist
  - uploaded attachment gives null filename

- Keyword Admin:
  - #edit margins too big? _(narrow viewport)_ `.arm_forms` needed a width declaration
  - #show missing _narrow viewport_ directive

- pictures without titles show empty quotes in html title tag

look into other ways to generate/metaprogram the javascript for jplayer
_No, wait to see if a switch to videojs ensures future operability before working on jplayer scripts_

- drop column article#text_markup, #markup_parser
 (was replaced by #content_*)

Why don't video coverpictures show in the index?

migration:   - video rename_column source_catalog_file_path source_imported_file_path

- *Links#index* doesn't see joined infopages
- *Links#show* needs standardization.

- More useful 'index' action for resources **almost done**
  - **Remove `_index` and `_show` partials when done.**

- drop table info_page_links
