class SearchPage < Page
  class << self
    def page
      self.find(:first) || FileNotFoundPage.find(:first)
    end
  end
end