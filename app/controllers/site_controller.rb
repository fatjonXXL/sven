class SiteController < ApplicationController
  session :off
  skip_before_filter :verify_authenticity_token
	
  def index
    params[:url] = '/'
    show_page
  end
  
  def show_page
    response.headers.delete('Cache-Control')

    url = params[:url]
    if Array === url
      url = url.join('/')
    end
    url = url.to_s

		requested_format = url.split('.')
		if requested_format.size > 1
			format = requested_format[1].to_sym
			url = requested_format[0]
		else
			format = :html
    end

		url = "/" if url.match(/index/)

    @page = Page.find_by_url("/#{url}")
		show_uncached_page(url, format)
  end

	def change_language
		Sven::LanguageHolder.language = params[:lang]

		redirect_to :back
	end
	
	def search
	  SearchPage.args = { :found => (Page.search(params[:search], {:conditions => ['status_id = ?', Status[:published].id]}) if params[:search]), :search => params[:search] }
	  redirect_to SearchPage.page.url
  end
  
  private
    def show_uncached_page(url, format = :html)
      unless @page.nil?
				case @page.status
					when Status[:published], Status[:hidden]
						@page.process(request, response, format)
						@performed_render = true
					else
						render_not_found_page
        end
      else
        render_not_found_page
      end
    end
end
