class Configuration < ActiveRecord::Base
	set_table_name :config
  serialize :value

	class << self
		def [](key)
			pair = find_by_key(key)
			unless pair.nil?
			  pair.value
		  else
		    ""
		  end
		end

		def []=(key, value)
			pair = find_by_key(key)
			if pair
				pair.value = value
				pair.save
			end

			return value
		end
	end
end