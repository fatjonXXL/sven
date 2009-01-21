module Sven
	module Version
		Major = '0'
		Minor = '6'
		Tiny  = '9'

		class << self
			def to_s
				[Major, Minor, Tiny].join('.')
			end
			alias :to_str :to_s
		end
	end
end

require 'lib/sven/nil_ext'