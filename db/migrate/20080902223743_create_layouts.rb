class CreateLayouts < ActiveRecord::Migration
  def self.up
		say						"LAYOUTS"
		say					  "-------------"

    create_table :layouts do |layout|
      layout.string :name
      layout.text :content
			layout.string :content_type, {:default => 'text/html'}
    end

		# INITIAL DATA
		say						"loading initial data ..."
		Layout.create :name => 'Standardní', :content => '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"><html><head><title><s:full_title /></title><s:stylesheets /><meta http-equiv="content-type" content="text/html; charset=utf-8" /></head><body><div class="main"><a id="top"></a><div class="topmenu"><s:menu /></div><div class="main-content"><s:template_content /></div><div style="clear: both;"></div></div></body></html>'
		Layout.create :name => 'Prázdný', :content => '<s:template_content />', :content_type => 'text/css'
  end

  def self.down
    drop_table :layouts
  end
end