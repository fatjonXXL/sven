class Rss < Page
	def headers
		{ "Content-Type" => "application/xml" }
	end
end