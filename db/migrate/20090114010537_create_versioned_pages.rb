class CreateVersionedPages < ActiveRecord::Migration
  def self.up
    # VERSIONS
    Page.create_versioned_table
  end

  def self.down
    Page.destroy_versioned_table
  end
end
