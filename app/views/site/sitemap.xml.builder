xml.instruct!
xml.urlset(:xmlns=>'http://www.sitemaps.org/schemas/sitemap/0.9') {
	@pages.each do |page|
    xml.url {
	    xml.loc("http://comz.cz" + page.url)
	    xml.priority( 0.9 - ( page.level.to_f / 10 ) )
			xml.lastmod(Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S+01:00"))
			xml.changefreq('daily')
		}
	end
}