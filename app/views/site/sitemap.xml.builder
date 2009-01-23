xml.instruct!
xml.urlset(:xmlns=>'http://www.sitemaps.org/schemas/sitemap/0.9') do
	@pages.each do |page|
    xml.url do
	    xml.loc(@site + page.url)
	    xml.priority( 0.9 - ( page.level.to_f / 10 ) )
			xml.lastmod(page.updated_at.utc.strftime("%Y-%m-%dT%H:%M:%S+01:00"))
			xml.changefreq('daily')
		end
	end
end