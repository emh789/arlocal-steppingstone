# A&R.Local To-Do List


## HIGHEST priority

finish admin renovation

  - scopes intersect with visibility
    - models `does_have_published_{resource}` and counter_cache
    - [].any vs [].count

  - `admin/isrc/edit` narrow view buttons overflow right

  -  **audio.title album_audio.title and event_audio.title all have some legacy methods**

  - autokeyword not fully implemented
    - remaining: article, infopage, link, stream

  - Keyword Admin:
    - #edit?videos missing buttons
      - **Finish implementation of video joins submenus; look across resources; also within video#edit**

## HIGH priority

Admin Resource Indexes are starting to have 'selectable' components and forms (`admin_index_filter_select`) in the style of `form_metadata.selectable`. However, the existing `form_metadata` modules exclusively serve the `#edit` action. Indexes currently get their selectable values from `{resource}_helper` methods. _(see also in 'Medium priority')_

- check Admin:Event#edit and #show for public view button

**- Video player layout could be improved at narrow widths.**
***- jplayer Audio player has not been updated in 10 yrs. Can videojs replace it?***

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


Audio Id3 tags:
  - AUdioHelper#audio_read_source_metadata
  - is audio_helper the best place for the method?
  - used in `app/views/admin/audio/_form_id3.haml`

- `form_helper` has one current and several obsolete methods that describe specific form attributes,


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

+ Font-Awesome
  - buttons that are a stylized anchor use font-awesome svgs as a background image within an inner `<span>`
  - buttons that are an `<input>`  cannot take innerHTML elements, only text as a `value=` attribute
  - is using the font-awesome webfont the only way to use fa-icons in the `<input>` buttons?

## Low Priority

- administrators/sign_in
  - Is it worth getting `devise::rememberable` to work correctly?

- Audio index

**Continue to be mindful about including `autocomplete: false` in form elements.**

- `links_helper` need some review
  - #link_parse_email
  - #link_parse_web
  - redundancy, confusion, could be refactored.
  - _Complicated. Reduce to low priority._



## Might need revisiting

- `[resource]_admin_link_title`
  - why `gsub('/','/&shy;')` in album_*_title?
    **Soft hyphen after a forward slash**
    *For what resource was this designed (and afterwards copypasta-ed)*
      - Filepaths?
      ***YES. PICTURE AND AUDIO.***
  - Removing it to see what happens.
  - Replace if needed.



## Possibly finished

- Link.name should be Link.title for consistency. _wait to look for add'l migrations, do all together_
  - **But `#name` is the name of the destination, not the title of the link.**
  - _Visited this topic before, and kept name._
  - Create semantic sugar method if needed.


- give a title to nested_picture uploads/imports

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

- **Sorting:**
  - Time values (date_released, etc) needs a value instead of nil because `nil` does not compare with `Date`
    - however, a value of Date.new(0) breaks the date-select year field (range: -5...5).
    - _use a `date_released_sortable` method to wrap the attribute when sorting._
      - done: audio, album, video

- check attribute callbacks, add if_changed clause

- admin:keyword#edit joined pictures lack 'remove' box

- `[resource]_admin_title_link` vs `[resource]_reference_admin_link`
  - **should get renamed in a way similar to each other**
    - `Album` is model.
    - administrators N/A
    - album ok, no longer needs _slug (was _reference)
    - articles ok
    - audio ok
    - events ok
    - infopages ok
    - links ok
    - pictures ok
    - streams ok
    - videos ok
  - `[resource]_admin_title_link` vs `[resource]_reference_admin_link`
    - title vs functional slug/datetime
    - *call it what it does*

    - Why the triage method in resources_helper #resource_reference_admin_link?
      - to manage differing _reference_ attributes across shared partials?
        - i think so. title vs slug vs date_and_venue vs destination_name
        - ISRC.
        - Keep the method but rename it more clearly.
      - was this approach ever implemented YES.

- !!! admin#show &c:  text_props fields have extra margin
  - `parsers_helper#parser_div` adds a `.arl_markup_parser_markdown` class wrapper
  - does `.arl_markup_parser_markdown` class still negate the default margin?

- admin removation
  - link
    - add_column :visibility, 'unlisted'
  - why called `admin_review_isrc_sorter_id` and not `admin_index_isrc_sorter_id`
  - ISRC sort_order selection on isrc#index and #show
  - ISRC form doesn't update; 'unpermitted attribute: id'
  - add commented attribute names in arlocal_settings
  - Keyword index needs indicators for "can_select_[resource]"
    - and migration to add  can_select_audio
  - {}_parser_id => {}_parser_type
    - MarkupParser makes more sense with simplified symbols than with numeric id
      - markdown      - `markdown`
      - plain text    - `plaintext`
      - single line   - `string`
  - {}_sorter_id => {}_sort_method
    - mostly arlocal_settings
    - album and event
    - Done, just remove `{}_sorter_id` database columns

- fix http://localhost:3000/admin/albums/:id/edit?pane=picture_import
  - build_picture
- fix http://localhost:3000/admin/albums/amidst/edit?pane=picture_join_by_keyword
  - pictures_count

- re-enable link validations

- index filter selects

- *Review builder methods for currency**

- *Review helper methods for currency in light of recent refactoring frenzy.*
  - admin_nav ok
  - administrators ok
  - albums ok
  - arlocal ok
  - articles ok
  - attribute ok
  - audio some bad smells: []_file_source_path etc. []_read metadata
  - button ok
  - events ok
  - form_helper has one current and several obsolete methods that previously described some form attributes,
  - html_head ok
  - icon ok
  - infopages ok
  - isrc ok
  - javascript ok
  - keywords ok
  - links ok
  - parsers ok
  - pictures ok
  - resources ok
  - routing ok
  - selectors ok
  - source_imported ok
  - streams ok
  - videos ok
  - visibility ok
  - welcome ok
  - helper methods
    - source_imported ok; removed obsolete methods that had previously been commented-out
    - visibility has the same integer/keyword id issue that `_markup_type` and `_sort_method` recently committed to keyword
      - id is sort order. models and helpers use `.title`

migrations:
  - delete old migrations and lib/* migration-related classes

Where to Sort vs Where to Query
  - previously depended more on a variety of singleton scopes chained in the controller
  - current scopes are for public/private visibility
  - Most sort methods are held in the Query; exceptions are album_ and event_pictures
    - _`Album` is the model for refactoring._

- ArlocalSettings
  - AutoKeyword attributes are [FILTERED], but why/how?
    - `config/initializers/filter_parameter_logging.rb`
    - config.filter_parameters, partial match on `:_key`
    - best to change attribute name
    - _Done. Last, verify that admin view forms are handled and nested correctly._
      - some forms need a `fields_for`
        - No. `fields_for` and `{resource}_keyword` building now happens in the shared `_auto_keyword` partial

- question remains of how to handle `year` parameter
  - multiparameter fields (album.date_released, date_select) cause difficulty validating
  - multiple attributes (audio.duration) lack elegance & require multiple columns, but fit better with rails conventions
  - ***wowee zowee date_field helper solves this!***
    - see if it fixes _datetime_zone.haml
    - *Yes, if I can finally understand how to make the time zones work!!*
    - datetime to text inputs instead of selects (why? I forget.) _To avoid over/under parametizing._ Maybe just the year field? The others are fixed and cyclical.

- `admin/welcome/markup_types` needs dynamic layout. grid fixes this. _no it doesn't_
  - **Might need a rewrite with a `param` and `<select>`**
  - panes: summary, simpleformat, markdown, none
  - about_arlocal
    - formatting for markup types, esp. for narrow width

- picture titles show markup in joined_resources
- picture_options_for_select picture.title_for_select
  - still shows markup
  - not sure why/how. re-saving each picture fixes it

- `views/admin/shared/_index_joined_pictures` and `…/_show_join_pictures`
  - currently using `picture.title_without_markup`
  - formatting is inconsistent with `parser_div(picture.title_props)`
  - *title_props would be preferable. fix the formatting.*
  - *layout glitch comes from nested <p> in parser_result*

- visibility touchup
  - public      publicly_linkable published publicly_indexable
  - unindexed   publicly_linkable published
  - unlisted    publicly_linkable
  - private

- picture_keyword checkboxes are still oldschool css

- Builder methods
  - some specify empty string for _markup_text; others are nil. What difference?
    - difference looks like formality and thoroughness, nothing functional
    - keep '' with arlocal_settings because all other options need a starting value
    - but it looks unnecessary on other resources with fewer required defaults

- scope for publicly_indexable looks very complicated
  - change date_released to a datetime_released; or,
  - improve method for determining today's date
    `lib/find_published.rb` *FindPublished.date_today*
  - converted to scopes:
    - Album etc. **includes OK**
    - Article (see backtrack via InfoPageItem) **includes OK**
    - Audio (no current backtracks) **includes OK**
    - Event **includes OK**
    - Infopage (scoped, but not implemented in `Link` or public views) **includes OK**
    - Keyword **includes OK, sort_by_keyword Ok**
    - Link

- match nomenclature in ResourceJoined models with whatever ^^^ decides
  - # Album v/
    - has_many
      - audio_published
      - pictures_published
    - joins
      - album_audio   :album audio_published_count
      - album_picture :album pictures_published_count
  - # Audio v/
    - has_many
      - albums_published
    - joins
      - album_audio :audio album_published_count
  - # Event *Doesn't use `published` yet*
  - **Make the infrastructure now, because you *will* use it for v1.**
    - has_many
      - audio_published
      - pictures_published
      - videos_published
    - joins
      - event_audio   :event audio_published_count
      - event_picture :event pictures_published_count
      - event_video   :event videos_published_count
  - # Keyword v/
    - has_many
      - albums_published
      - audio_published
      - pictures_published
      - videos_published
    - joins
      - album_keyword   :keyword albums_published_count
      - audio_keyword   :keyword audio_published_count
      - picture_keyword :keyword pictures_published_count
      - video_keyword   :keyword videos_published_count
  - # Picture v/
    - has_many
      - albums_published
      - videos_published
    - joins
      - album_picture :picture albums_published_count
      - video_picture :picture videos_published_count
  - # Video v/
    - has_many
      - pictures_published
    - joins
      - video_picture :video pictures_published_count

- video#edit?keyword uses old checkbox

- `Audio.title` should avoid calling *super*
  - find why and make a semantic sugar method

  - Event datetime could use datetime_field form helper
    - however, the app uses the time entered in the zone local to the event
    - whereas rails assumes Time is local to the app and converts it to UTC
    - I don't yet see how to preserve the event timezone independently of UTC and local app timezone conversions
    - will require a database migration to merge separate columns into a single datetime column
  - Same issue with picture datetime_manual_entry
  - maybe use around_action filter in controller
  - see https://api.rubyonrails.org/classes/Time.html#method-c-use_zone
  ```
  class ApplicationController < ActionController::Base
    around_action :set_time_zone

    private
      def set_time_zone
        Time.use_zone(current_user.timezone) { yield }
      end
  end
  ```
  - and also for Models/views
  ```
  datetime_utc.in_time_zone(datetime_zone)
  datetime_field
  datetime_local_field
  pattern="[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}" required
  ```
  - So many contradictions here. Best option seems to be datetime_field despite not having yyyy-mm-dd format

- Picture datetime can be simplified. See `@event.datetime`
