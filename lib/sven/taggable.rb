module Sven::Taggable
  mattr_accessor :last_description, :tag_descriptions
  @@tag_descriptions = {}
    
  def self.included(base)
    base.extend(ClassMethods)
    base.module_eval do
      def self.included(new_base)
        super
        new_base.tag_descriptions.merge! self.tag_descriptions
      end
    end
  end
  
  def render_tag(name, tag_binding)
    send "tag:#{name}", tag_binding
  end
  
  def tags
    Util.tags_in_array(methods)
  end
  
  def tag_descriptions(hash=nil)
    self.class.tag_descriptions hash
  end
  
  module ClassMethods
    def inherited(subclass)
      subclass.tag_descriptions.reverse_merge! self.tag_descriptions
      super
    end
    
    def tag_descriptions(hash = nil)
      Sven::Taggable.tag_descriptions[self.name] ||= (hash ||{})
    end
  
    def desc(text)
      Sven::Taggable.last_description = Util.strip_leading_whitespace(text).to_s # PRIDAT REDCLOTH
    end
    
    def tag(name, &block)
      self.tag_descriptions[name] = Sven::Taggable.last_description if Sven::Taggable.last_description
      Sven::Taggable.last_description = nil
      define_method("tag:#{name}", &block)
    end
    
    def tags
      Util.tags_in_array(self.instance_methods)
    end
    
  end
   
  module Util
    def self.tags_in_array(array)
      array.grep(/^tag:/).map { |name| name[4..-1] }.sort
    end
    
    def self.strip_leading_whitespace(text)
      text = text.dup
      text.gsub!("\t", "  ")
      lines = text.split("\n")
      leading = lines.map do |line|
        unless line =~ /^\s*$/
           line.match(/^(\s*)/)[0].length
        else
          nil
        end
      end.compact.min
      lines.inject([]) {|ary, line| ary << line.sub(/^[ ]{#{leading}}/, "")}.join("\n")
    end      
    
  end
  
end