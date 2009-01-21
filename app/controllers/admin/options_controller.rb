class Admin::OptionsController < ApplicationController
  permission_required :manage_options

  def index
		@options = Configuration.all
  end

	def save
		Configuration.all.each do |configuration|
			configuration.value = ""
			configuration.save
    end

		params[:option].each do |option|
			Configuration[option[0]] = option[1]
    end

		respond_to do |format|
			flash[:notice] = "Nastavení uloženo"
			format.html { redirect_to(admin_options_url) }
    end
  end
end
