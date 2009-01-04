class Layout < ActiveRecord::Base
	def self.get_select
		self.all.map { |l| [l.name, l.id] }
	end
end
