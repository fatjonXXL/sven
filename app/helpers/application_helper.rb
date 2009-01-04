# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def	hrefoptions(where_i_am_now)
		ev = "#{eval(where_i_am_now)}"
		return { :class => "now" } if ev.blank? == false and request.request_uri.strip == ev
		return nil
	end
	
	def showmore(elem, changeElem)
	 "<a href=\"#\" id=\"show-more\" onclick=\"return show_hide('#{elem}', '#{changeElem}', '[+] zobrazit nastavení', '[-] skrýt')\">[+] zobrazit nastavení</a>"
	end
end
