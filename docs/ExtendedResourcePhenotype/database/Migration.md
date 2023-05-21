creates a [[Join Table]] on the database

Ordering logic belongs on the join model. Therefore, the `create_join_table` method for a  `has_and_belongs_to_many` relationship will not work in most cases. 

```
create table :resource_target do |t|
	t.integer :resource_id
	t.integer :target_id
	t.integer :resource_order
	t.index :resource_id
	t.index :target_id
end

add_column :resources, :target_count, :integer
add_column :targets, :resource_count, :integer
```
