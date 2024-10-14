# A&R.Local To-Do List


## HIGHEST priority

- article & keyword need full implementation in views.

- audio.published might not be finished. There is not yet an audio index, so this had been delayed.
  - .published is defined but check for full join support and implementation.

- counter cache for infopage articles, links, pictures
  - it's polymorphic, can be consolidated via infopage_items but not easily distinguished.

- does Video:Form-picture-import/upload need autokeyword

- Keyword Admin:
  - #edit?videos missing buttons
    - **Finish implementation of video joins submenus; look across resources; also within video#edit**

Check where display_title and title_sortable overlap. They may be approaching the same problem from different angles: what to say/do when a indexing value (title, datetime) is undefined.
  - Audio: `title_sortable` is messy but serves the current `sort_by! … full_title` approach. Refactor somehow.
  -  **audio.title album_audio.title and event_audio.title all have some legacy methods**


## HIGH priority

- Articles, Links, and Pictures lack a pane for infopages.

Admin Resource Indexes are starting to have 'selectable' components and forms (`admin_index_filter_select`) in the style of `form_metadata.selectable`. However, the existing `form_metadata` modules exclusively serve the `#edit` action. Indexes currently get their selectable values from `{resource}_helper` methods. _(see also in 'Medium priority')_ This discrepancy arose because `form_metadata` modules serving the `#edit` action frequently invoke ActiveRecord, whereas the `#index` action selectables were a part of the application structure and `Sorter` object definitions.

Admin views public_index/show buttons should use a "preview" action instead of bouncing to public

- check Admin:Event#edit and #show for public view button

**- Video player layout could be improved at narrow widths.**
***- jplayer Audio player has not been updated in 10 yrs. Can videojs replace it?***
      - Yes, but it will require additional custom code, and it will change the look-and-feel.
      - and it uses npm which puts diarrhea everywhere

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

- event.announced/published might not be finalized. (This had been considered irrelevant.)
  - .announced is defined, but there is not yet an date_announced attribute. OK to finish join support.
    - *except…* audio/pictures/video would be more applicable for Event.past rather than Even.announced.
    - why would this be useful? if media is from a past event, how would there be multiple joins?
    - maybe coverpicture? But then `announced` would be better
    - keywords maybe.
    - Is this a YAGNI item?



## Medium priority

- Should html_head title elements include the resource type? Would help add clarity to browser history.
  - examples:
    - picture: album cover
    - album: Diamonds in the Ruff
  - see Picture for code

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

- arlocal_settings => user.settings has_one
  - would require dividing application settings (eg. marquee) form user preferences (admin index order)

- Audio index

**Continue to be mindful about including `autocomplete: :off` in form elements.**

- `links_helper` need some review
  - #link_parse_email
  - #link_parse_web
  - redundancy, confusion, could be refactored.

  autokeyword smells bad.
  _Could be replaced by `Add [resource] to Keyword`_
    - This gets complicated quickly.



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

      - *check for `_sortable` methods on joined_resource sorting.*
        - Album v/
        - Article v/
        - Audio v/
        - Event v/
        - Keyword v/
        - Picture v/
        - Video v/

- `admin/isrc/edit` narrow view buttons overflow right
- why does `size: ` attribute result in larger-than-size fields? inherited from CSS maybe?
  - for example `admin/isrc/edit` overflows at narrow widths.

- Admin::Articles#index: `content` section might get extremely vertical. Maybe add overflow-y and max-height?
  - no, it's okay – uses `content_beginning_props`

- autokeyword not fully implemented
  - remaining: article, infopage, link, stream
  - if anything, only `article` needs it
  - the @autokeyword controller variable could be replaced by adding resource.keyword.build to a builder method
    and testing for its presence in the view.
  - look for where `build_with_defaults` would more accurately be `build_with_defaults_and_autokeyword`

- autokeyword refactor needed a distinction between joined_resources and joined_resources_sorted
  - check joined_resource views. update methods.

fixing the multi-field spacing elminiated proper padding on markup_type-select
_nope, just a typo_

- duration attributes in forms would look better with leading zero

- article_keyword needs counters

- scopes intersect with visibility
  - models `does_have_published_{resource}` and counter_cache
  - [].any vs [].count
    - `.any` requires a db query UNLESS the parent search had an `.includes()` method
- Counter cache support for `published` scopes as a table column is unfeasible because it requires a variable evaluation (current date).
