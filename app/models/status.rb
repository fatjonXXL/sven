class Status	
  attr_accessor :id, :name, :symbol

  def initialize(options = {})
    options = options.symbolize_keys
    @id, @name, @symbol = options[:id], options[:name], options[:symbol]
  end
	
  @@statuses ||= [
    Status.new(:id => 1,   :name => 'Návrh',				 :symbol => 'draft'			),
    Status.new(:id => 50,  :name => 'Zkontrolováno', :symbol => 'reviewed'	),
    Status.new(:id => 100, :name => 'Publikováno',	 :symbol => 'published'	),
    Status.new(:id => 101, :name => 'Schovaný',			 :symbol => 'hidden'		)
  ]
  
  def symbol
    @symbol.intern
  end
  
  def self.[](value)
    @@statuses.find { |status| status.symbol == value.to_s.downcase.intern }
  end
  
	def self.find(*args)
		options = args.extract_options!
		
		case args.first
			when :first then return self.find_initial(options)
			when :all   then return self.find_every(options)
			else             return self.find_from_ids(args, options)
		end
  end

	def self.get_select
		self.all.map { |s| [s.name, s.id] }
  end
  
  def self.all(options = {})
    self.find_every(options)
  end

	private
		def self.find_initial(options)
			@@statuses.first
		end

		def self.find_every(options)
			@@statuses.dup
		end

		def self.find_from_ids(id, options) 
			@@statuses.find { |status| id.to_s == status.id.to_s }
		end
end