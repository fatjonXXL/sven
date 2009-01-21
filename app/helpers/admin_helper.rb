module AdminHelper
  def delete_link( url, options={} )
    options = { :permission => :destroy_content, :confirm => "Opravdu smazat?", :method => :delete, :icon => { :position => :front, :name => :delete } }.merge( options )
    link_to "smazat", url, options if current_user.has_permission?( options[:permission] )
  end
  
  def add_link( text, url, options={} )
    options = icon(:add).merge( options )
    link_to text, url, options
  end
  
  def info_link( url, options = {} )
    options = icon(:information).merge( options )
    link_to "informace", url, options
  end
  
  def edit_link( url, options = {})
    options = icon(:page_edit).merge( options )
    link_to "upravit", url, options
  end
  
  def icon(name, position=:front)
    { :icon => { :name => name.to_sym, :position => position.to_sym } }
  end
  
  def build_table( options={} )
    options = {
      :columns => [{
        :name=>"",
        :text=>"",
        :class=>"",
        :id => ""
      }],
      :last_column_contents => [],
      :object => [],
      :table => {
        :class => "full-length small",
        :id => ""
      },
      :not_found_message => "Nic nenalezeno!"
    }.merge( options )  
    
    head_rows = ""
    options[:columns].each do |col|
      head_rows << "<th class=\"#{ col[:class] }\" id=\"#{ col[:id] }\">#{ col[:title] }</th>"
    end
    
    table_content = ""
    options[:object].each do |object|
      table_content << "<tr>"
      options[:columns].each do |col|
        table_content << "<td class=\"#{ col[:class] }\">#{ object[col[:name]] }</td>"
      end
      
      options[:last_column_contents].each do |last|
        table_content << "<td>#{ last }</td>"
      end
      table_content << "</tr>"
    end
    
    return <<-table
      <table class="#{ options[:table][:class] }" id="#{ options[:table][:id] }">
	      <thead>
		      <tr>
		        #{ head_rows }
			      <th class="modify">Možnosti</th>
		      </tr>
	      </thead>
	      <tbody>
		      #{ table_content }
	      </tbody>
      </table>
      #{ options[:not_found_message] if options[:object].blank? }
    table
  end
  
	def make_formable( option, field="option", options = {} )
	  options = { :breaks => false, :class => "" }.merge( options )
		values = eval(option['values']) unless option['values'].blank?
		value = option['value'] == nil ? "" : option['value']
		
		case option['option_type']
			when 'text'
				return text_field_tag("#{field}[#{option['key']}]", value, { :size => 60, :class => options[:class] })
			when 'select'
				return select_tag("#{field}[#{option['key']}]", options_for_select(values, value), :class => options[:class]) unless values.blank?
			when 'check'
				unless values.blank?
					check_boxes = []
					for check in values
						check_boxes << "#{ check_box_tag( "#{field}[#{option['key']}][]", check[1], (value.include?(check[1].to_s)), :class => options[:class] ) }&nbsp;#{ t check[0], :default => check[0] }"
					end

					return check_boxes.join( ( options[:breaks] ? "<br />" : "&nbsp;" ) )
				end
			when 'radio'
				unless values.blank?
					radio_buttons = []
					for radio in values
						radio_buttons << "#{radio_button_tag("#{field}[#{option['key']}]", radio[1], ( ( value == radio[1] ) ? { :checked => true } : nil ), :class => options[:class])}&nbsp;#{ t radio[0], :default => radio[0] }"
					end
				
					return radio_buttons.join( ( options[:breaks] ? "<br />" : "&nbsp;" ) )
				end
			else
				""
    end
  end
end
