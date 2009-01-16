class Page < ActiveRecord::Base
	before_validation :make_slug
	
	include Sven::Taggable
  include Sven::StandardTags
	
	cattr_accessor :args

	acts_as_nested_set :text_column => 'title'
	acts_as_paranoid
	acts_as_versioned

	belongs_to :layout
	belongs_to :template, :class_name => 'ContentTemplate'
	has_many :annexes
	has_many :images
	has_many :parts, :class_name => 'PagePart'
	has_many :files, :class_name => 'Filet'
	has_many :children, :class_name => 'Page', :foreign_key => 'parent_id', :dependent => :destroy
	
	set_inheritance_column :class_name

	validates_presence_of :title
	validates_presence_of :layout
	validates_presence_of :status

	#define_index do
  #  indexes title, :sortable => true
	#	indexes body

  #  has created_at, updated_at
  #end
    
  def published?
    status == Status[:published]
  end

	def status
    Status.find(self.status_id)
  end
	
  def status=(value)
    self.status_id = value.id
  end
	
  def process(request, response, format = :html)
    @request, @response = request, response
    headers.each { |k,v| @response.headers[k] = v }
    @response.headers['Content-Type'] = Mime.const_get(format.to_s.upcase).to_s if @response.headers['Content-Type'].blank?
    @response.body =	case format
												when :pdf
													Sven::PdfGenerator.render(render)
												else
													render
											end
    @request, @response = nil, nil
  end
	
	def render
    if layout
      parse_object(layout.content)
    else
			parse_object(body)#	render_part(:body)
    end
  end
   
  def headers
    { 'Status' => ActionController::Base::DEFAULT_RENDER_STATUS_CODE }
  end

	def url
		get_url(self).flatten.reverse.join("/").gsub(/\/\//, '/')
  end
  
  def nbsp_title
    returning "" do |title|
      self.level.times do 
        title << "&nbsp;&nbsp;"
      end
      title << self.title
    end
  end

	class << self
		def find_by_url(url)
			Page.all.detect { |page| page.url == Page.clean_url(url) and (page.language == Sven::LanguageHolder.language or not page.class_name == "Page") } # rscue raise Page::MissingRootPageError
    end

		def clean_url(url)
			"/#{ url.strip }".gsub(%r{//+}, '/')
		end

		def descendants
			[Page, Css, FileNotFoundPage, Rss, SearchPage].map { |klass| [klass.to_s, klass.to_s] }
		end
		
		def get_select
		  [["---", 0]] + self.all(:conditions => { :status_id => Status[:published].id, :class_name => "Page" }, :order => 'lft, title').collect { |page| [page.nbsp_title, page.id] }
		end
  end	

	private
		def lazy_initialize_parser_and_context
      unless @parser and @context
        @context = Sven::PageContext.new(self)
        @parser = Radius::Parser.new(@context, :tag_prefix => 's')
      end
      @parser
    end
    
    def parse_object(object)
			full_content = lazy_initialize_parser_and_context.parse(object)
			full_content = lazy_initialize_parser_and_context.parse(full_content)
			full_content = lazy_initialize_parser_and_context.parse(full_content)
			full_content
    end

		def get_url(id)
			urls = []
			object = Page.find id
			urls << object.slug if object.slug
			unless object.parent_id.nil?
				urls << get_url(Page.find(object.parent_id))
      end

			return urls
		end

		def make_slug
			self.slug = self.title.mb_chars.downcase.strip.normalize(:kd).to_s.gsub(/[^\x00-\x7F]/, '').tr_s(' ', '-').gsub(/[^0-9a-z-]/, '') if self.slug.blank?
		end
end
