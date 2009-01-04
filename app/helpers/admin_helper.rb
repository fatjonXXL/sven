module AdminHelper
  def delete_link( url, options={} )
    options = { :confirm => "Opravdu smazat?", :method => :delete, :icon => { :position => :front, :name => :delete } }.merge( options )
    link_to "smazat", url, options
  end
  
  def add_link( text, url, options={} )
    options = { :icon => { :position => :front, :name => :add } }.merge( options )
    link_to text, url, options
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
end
