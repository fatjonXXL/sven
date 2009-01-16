module Admin::PagesHelper
	def pages_list
		@first_page ||= Page.find_by_slug '/'
		@menu = page_children
		@menu << "<tr><td colspan=\"2\"><h4>Vybraný jazyk: <strong>#{t session[:selected_language]}</strong></h4></td></tr>" if Configuration['site.langs'].size > 1

		@menu
  end
  
	def tag_reference(class_name)
		returning String.new do |output|
			class_name.constantize.tag_descriptions.sort.each do |tag_name, description|
				output << render(:partial => "tag_reference", :locals => {:tag_name => tag_name, :description => description})
			end
		end
	end

	def appendixize(appendix)
		returning String.new do |app|
			app << "<span class=\"small\">"
			if appendix.class_name == "Image"
				image = appendix.public_filename(:thumb)
			else
				extension = appendix.filename.split(".")[1]
				image = "/images/fileicons/#{extension}.png"
				image = "/images/fileicons/file.png" unless File.exist?("#{Rails.root}/public#{image}")
      end
			app << image_tag(image, { :style => "width: 16px; height: 16px;", :alt => appendix.filename})
			app << "&nbsp;&nbsp;#{appendix.filename}&nbsp;&nbsp;"
			app << link_to_remote("[-] smazat", :url => { :action => "remove_appendix", :id => appendix.id }, :update => 'appendixes', :confirm => 'Opravdu smazat ?')
			app << "</span><br />"
    end
	end

	private
		def page_children(parent = nil)
			childs = ""
			parent = parent == nil ? "IS NULL" : "= #{parent}"

			session[:selected_language] = (session[:selected_language] || "cz")
			
			for page in Page.find(:all, :conditions => ["parent_id #{parent} AND language = ?", session[:selected_language]], :order => 'class_name DESC, title ASC')
				klass = " style=\"display: none;\"" unless page.parent_id == @first_page.id or page.parent_id == nil
				childs << "<tr#{klass} class=\"page-#{page.parent_id}-child\" id=\"page-#{page.id}\">"
				childs << "<td style=\"padding-left: #{page_list_level(page.level, (page.all_children.size > 0))}px\">"
				childs << "<span class=\"page-list\">"
				expander = page.slug == '/' ? "collapse.png" : "expand.png"
				childs << image_tag("#{expander}", { :id => "page-#{page.id}-expander", :alt => 'zobrazit/schovat podstránky', :onclick => "image_show_hide('page-#{page.id}-child', 'page-#{page.id}-expander', '/images/expand.png', '/images/collapse.png')" }) unless page.all_children.blank?
				childs << "<span class=\"page-title\">#{ link_to( page.title, admin_edit_page_url( page ), icon( page.class_name.downcase.to_sym )) }</span>"
				childs << "</span>"
				childs << "</td>"
				childs << "<td class=\"status\">#{page.status.name}</td>"
				if page.class == Page
				  childs << "<td class=\"add-child\">#{link_to("přidat podstránku", admin_new_page_url( :parent => page.id ), icon( :page_add ))}</td>"
				  childs << "<td class=\"alter-parent\">#{link_to("změnit nadřaz. stránku", admin_edit_parent_page_url( page ), icon( :page_attach ) ) unless page.slug == '/'}</td>"
				else
				  childs << "<td></td><td></td>"
			  end
				childs << "<td class=\"remove\">#{delete_link( admin_destroy_page_url( page ) ) if (not page.slug == '/') and current_user.has_permission?(:destroy_content)}</td>"
				childs << "</tr>\n"
				unless page.children.blank?
					childs << page_children(page.id)
				end
			end
			if childs.blank?
			  childs << "<tr><td colspan=\"2\">Nebyly nalezeny žádné stránky</td></tr>"
			end			
			childs
		end

		def page_list_level(level=0, children=false)
			list_level = (level*35)
			list_level -= (level*22) if children
			list_level
		end
end
