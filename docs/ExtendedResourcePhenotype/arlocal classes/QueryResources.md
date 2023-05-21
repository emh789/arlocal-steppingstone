The complexity and interconnectedness of database query methods led to the development of a specific QueryResources class. The resource singleton space stays unchanged from its ActiveRecord::Base inheritence, and remains uncluttered with logic involving other resource classes.

Some query methods are determined by a value in [[arlocal_settings]] that refers to a Proc in the respective [[Sorter]]

Calls the [[Model]] singleton methods from the ActiveRecord Query Interface.