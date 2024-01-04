# A&R.Local To-Do List


## HIGHEST priority

finish admin renovation
  - admin pages: html subtitle could benefit from including resource class ("editing album @album.title")
  - `admin/welcome/markup_types` needs dynamic layout. grid fixes this. _no it doesn't_
    - **Might need a rewrite with a `param` and `<select>`**
    - _Grid layout fixes many of the other welcome content pages._
  - `admin/isrc/edit` narrow view buttons overflow right
  - give a title to nested_picture uploads/imports
  - More useful 'index' action for resources *working on it*
    - **Audio is the model for Picture.**
  - *Review helper methods for currency in light of recent refactoring frenzy.*
    - Keyword Admin:
      - #edit margins too big? _(narrow viewport)_
      - #edit?videos missing buttons
        - **Finish implementation of video joins submenus; look across resources; also within video#edit**
      - #show missing _narrow viewport_ directive
    - Links_helpers need some review for currency and effectiveness

video#show css
  text_data, does it need a min-width?
Video index needs headings

Not sure what these were from: _(but probably from the EventVideo addenda)_:
  + form_metadata
  + partials
    + event _form_join_by_keyword,
      + method keyword.title_with_video_count
    + event _form_join_single
    + video join_single


Not sure what these were from _(but probably from the EventVideo addenda)_:
---
  - Fallout
    - models/event_audio.rb: what is self.event_hash and why?
    - FormVideoMetadata:
      - look for 'selectable: { :@pictures => lambda { |arlocal_settings| QueryPictures.options_for_select_admin_with_nil(arlocal_settings) } }'
      - no need for lambda? **probably not.**
      - do we even need it in pictures: ?  line 51
    - event datetime
      model: datetime_zone not applies anymore?
             datetime_formatted.to_s(format) doesn't accept format variable?
###     !!! `Time.zone = datetime_zone; Time.zone.local(**).to_fs(format)`
---



## HIGH priority

- datetime to text inputs instead of selects (why? I forget.) _To avoid over/under parametizing._ Maybe just the year field? The others are fixed and cyclical.
  - why does `size: ` attribute result in larger-than-size fields? inherited from CSS maybe?


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

- eventshelper:158 why assign js empty?

- pictures_helper picture_preferred_url
  - check if picture exists (add file_exists? method to model)
  - if not, return a dummy html_class to guarantee minimal dimensions
- form_pictures exerwhere
- picture_selector in join_single



## Medium priority

autokeyword smells bad.

Had AudioHelper.audio_read_source_metadata been refactored into a builder method? *no* If not, should it be? *no, if anywhere then into the Album model*
  - used in `app/views/admin/audio/_form_id3.haml`

- import/upload video via `keywords/_form_video_import`

- change the Calendar model from a module to a class
  - **Compare with video_group.** Maybe it's best as a query method?

- admin:audio#edit?id3 needs some refinement.
  - columns
  - is audio_helper the best place for the method?

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

look into other ways to generate/metaprogram the javascript for jplayer



## Possibly finished

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


finish admin renovation:
  - TEST EVERY ACTION. LOTS OF CODE GOT RENAMED.
    - live trials suggest this is complete.
  - `admin/#{resource}/edit` category panes have crazy border


Investigate which `Class.options_for_select_admin` could be optimized with a `.select` or `.pluck` to get only the needed fields for a form select element



## Probably finished

- admin display review
  - refactor index_joined_resource view templates
    fallout: keyword_statement_items_count methods might be unused now
    (replaced by resource_statement_items_count)
    - looks like it from Album and Picture helpers
    - in `_form_[resource]`

Renaming source_imported etc resulted in a naming collision
  - resource_model: audio.source_imported_file_path for relative to public/portfolio
  - source_imported_helper: source_imported_file_path(audio) for absolute path to look for file
because Audio.file_exists? is dependent on both the source type and the config.x.arlocal configuration setting for public/portfolio

keyword scopes
Picture queries rely on instance methods rather than databse attributes
    effective datetime value, for example, selects from a hierarchy of three values (manual entry, exif, file)
  harder to refactor into model scopes w/o corresponding database attribute
    **Maybe bypass model scopes and just use a sorted array?**
  should this change?
Video scope
  sort_by_keyword -> can this be refactored into model scope?
**Some complex queries return a hash rather than an ActiveRecord::Association array.**
**Maybe they should be kept separate from the ActiveRecord#scope methods?**
***Conclusion***
  - keep scopes for visibility: indexable, linkable, published, etc.
  - use collection variable in `fields_for` blocks, &c.
  - assume that the query will deliver an enumerable

javascript_helper could be split into jplayer_helper. *No. Just remove obsolete google analytics methods.*
would be nice to look into other ways to generate/metaprogram the javascript for jplayer *Yes, but low priority.* **It's easy. `require 'json'` do it**

Ongoing debate:
**When to use model scope vs. When to use Query method?**
  - some query results depend on values from instance methods rather than activerecord:query interface
  - some queries return a hash with result from database attribute or instance method as its keys
    - for example, calendar of events by year
  - compare picture (Query) w audio (scope)
  - Since we're using additional Query classes, move display-order methods to the Query class for consistency
    and reserve scopes for categorical distinctions (e.g. visibility)
**Still needs:**
  - Album v-
  - Event v-
  - Keyword v-
  - Video v-
**Possible fallout from removing scopes. Especially `Class.options_for_select_admin`**
  which itself could be optimized with a `.select` or `.pluck` to get only the needed fields for a form select element
*Comment out scopes but don't remove yet.*

Why does VideoBuilder include CatalogHelper? It seems unneeded and it breaks loading.

jplayer_playlist
  - uploaded attachment gives null filename

page html_head titles are inconsistent. Maybe just a single method ONE TIME, not a cumulative array.
`HtmlHelper.html_head_title_extend!` line 37
  - where does yield(:html_head_meta_description) get value?
    - look for `content_for :html_head_meta_description`

- why does infopages have an index_dup? is that project complete?
