class PagePart < ActiveRecord::Base
  before_validation :do_numbering
  belongs_to :page
  
  validates_uniqueness_of :name, :scope => :page_id
  
  def self.find_type( type, conditions = {} )
    conditions = { :conditions => ["name LIKE ?", "#{type}%"], :order => 'name' }.merge( conditions )
    self.find( :all, conditions )
  end
  
  private
    def do_numbering
      unless self.name.index(":")
        counter = 0
        last_object = self.class.find_type(self.name).last
        counter = last_object.name.gsub(/\w:/, '').to_i + 1 if last_object
        self.name << ":#{counter}"
      end
    end
end
