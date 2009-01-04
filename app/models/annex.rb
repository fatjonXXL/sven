class Annex < ActiveRecord::Base
	belongs_to :page

	set_table_name :appendixes
	set_inheritance_column :class_name
end
