class Admin::OptionsController < AdminController
  permission_required :manage_options, :except => [ :edit, :update, :forgotten_password, :regenerate_password ]

  def index
		@options = Configuration.all
  end

	def save
		Configuration.all.each do |configuration|
			configuration.value = ""
			configuration.save
    end

		params[:option].each do |option|
			Configuration[option[0]] = option[1].inspect
    end

		respond_to do |format|
			flash[:notice] = "Nastavení uloženo"
			format.html { redirect_to(options_url) }
    end
  end
end
