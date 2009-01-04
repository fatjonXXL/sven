class Menu < ActiveRecord::Base
  has_many :menu_items
  
  def self.get_select
    self.all.collect { |menu| [menu.name, menu.id] }
  end
end
