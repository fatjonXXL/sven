module Admin::PluginsHelper
  def valuable( value )
    case value
      when TrueClass:
        "ano"
      when FalseClass:
        "ne"
      else value
    end
  end
end
