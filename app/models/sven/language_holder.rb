module Sven
	class LanguageHolder
		@@language = "cz"
		def initialize
			@@language = "cz" unless @@language
		end

		class << self
			def language
				@@language = "cz" unless @@language
				@@language
			end

			def language=(lang)
				@@language = lang if exist?(lang)
			end

			def loaded_languages
				returning [] do |loaded|
					Dir[File.join(RAILS_ROOT, 'lang', '*.{yml,yaml}')].each do |file|
						loaded << File.basename(file, '.*').to_sym
					end
				end
			end

			def exist?(language)
				loaded_languages.include? language.to_sym
			rescue
				false
			end
		end
  end
end