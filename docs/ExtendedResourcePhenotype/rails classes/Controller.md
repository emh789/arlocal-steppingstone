renders [[View]]


## arlocal_settings

ApplicationController reads [[arlocal_settings]] and passes it to the :admin and :public resource controllers.

## params_permitted

nesting possibilites from the UI require permitting attributes from BOTH the [[has_many Join Model]] and [[has_many Target Model]] attributes

## find & create

prefer to use [[ResourceBuilder]] and [[QueryResources]] classes over resource singleton methods inherited from ActiveRecord::Base.

Many resources require specific, complex methods for creation and querying. Refactoring these methods out of the model's singleton space and into their unique classes made the entire codebase easier to read.

## edit

[[FormResourceMetadata]] provides form submenu partial name and selectable form items

## new

[[auto_keyword]]



