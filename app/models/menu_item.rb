class MenuItem < ActiveRecord::Base
  before_save :linkit
  
  belongs_to :menu
  acts_as_nested_set
  
  attr_accessor :page
  attr_accessor :url
  def published?
    self.published == 1
  end
  
  private
    def linkit
      self.link = ( self.page == 0 ) ? self.url : self.page
    end
end