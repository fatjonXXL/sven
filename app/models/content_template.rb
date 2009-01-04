class ContentTemplate < ActiveRecord::Base
	set_table_name :templates

	def self.get_select
		self.all.map { |l| [l.name, l.id] }
	end
end
