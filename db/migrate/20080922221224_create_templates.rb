class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates do |t|
      t.string :name
      t.text :content

      t.timestamps
    end
    
    ContentTemplate.create :name => 'Standardní', :content => '<s:content />'
    ContentTemplate.create :name => 'Hledání', :content => '<s:content /><br /><br />HLEDÁNÍ'
  end

  def self.down
    drop_table :templates
  end
end
