class Plugin
  def self.all
    returning [] do |plugins|
      Sven::AllowedPlugins.each do |plugin|
        plugins << plugin.classify.constantize if Engines.plugins[plugin.to_sym]
      end
      plugins.compact!
    end
  end
  
  def self.find( name = nil )
    return nil unless name or Sven::AllowedPlugins[].include?( name.to_sym )
    name.classify.constantize
  end
  
  def self.config( name = nil )
    return nil unless name or Sven::AllowedPlugins[].include?( name.to_sym )
    load_config( name )
  end
  
  def self.set_config( name = nil, config = {} )
    return nil unless name or Sven::AllowedPlugins[].include?( name.to_sym )
    
    begin
      configs = load_config( name )
      configs.each { |key, value| value['value'] = config[key.to_sym] unless config[key.to_sym] }
    rescue
      return false
    else
      File.open( File.join( Rails.root, 'config', 'plugins', "#{name}.yml" ), "w+" ) do |f|
        f << configs.to_yaml
      end
      return true
    end
  end
  
  private 
  def self.load_config( plugin )
    YAML.load( File.open( File.join( Rails.root, 'config', 'plugins', "#{plugin}.yml" ), "r" ) )
  end
end