class FileNotFoundPage < Page
	def header
		{ 'Status' => '404 Not Found' }
  end

	class << self
		def process(request, response)
			status_404 = FileNotFoundPage.find(:first)
			status_404 = Page.find_by_url('/') unless status_404
			status_404.process(request, response)
		end
  end
end