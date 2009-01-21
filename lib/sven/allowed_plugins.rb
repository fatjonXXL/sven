module Sven
  module AllowedPlugins
    def self.[]
      %w(authorization commented)
    end
    
    def self.each( &block )
      Sven::AllowedPlugins[].each(&block)
    end
  end
end