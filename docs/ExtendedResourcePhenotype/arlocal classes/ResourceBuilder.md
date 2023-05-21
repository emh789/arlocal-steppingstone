Reading metadata from an imported or uploaded file led to complex logic better suited for a builder method than the resource singleton space. Some default values derive from periphery classes not served by ActiveRecord.

Creates a resource [[Model]]

- default values for attributes
	- some from [[arlocal_settings]]. The builder will read the database if it does not receive an ArlocalSettings object when called.
- create a resource with given attributes and default values
- create from import/upload
	- read metadata and auto-populate database fields
	- create as a nested resource (when called from parent resource controller)
	- automatically join to another resource