module Admin::OptionsHelper
	def make_formable(option)
		options = eval(option.values) unless option.values.blank?
		value = option.value || ""
		
		case option.option_type
			when 'text'
				return text_field_tag("option[#{option.key}]", value, { :size => 60 })
			when 'select'
				return select_tag("option[#{option.key}]", options_for_select(options, value)) unless options.blank?
			when 'check'
				unless options.blank?
					check_boxes = []
					for check in options
						check_boxes << "#{check_box_tag("option[#{option.key}][]", check[1], (value.include?(check[1].to_s)))}&nbsp;#{check[0]}"
					end

					return check_boxes.join("<br />")
				end
			when 'radio'
				unless options.blank?
					radio_buttons = []
					for radio in options
						radio_buttons << "#{radio_button_tag("option[#{option.key}]", radio[1], (value == radio[1]))}&nbsp;#{radio[0]}"
					end
				
					return radio_buttons.join("<br />")
				end
			else
				""
    end
  end
end
