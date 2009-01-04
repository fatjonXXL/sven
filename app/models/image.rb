class Image < Annex
	has_attachment :content_type => :image,
                 :storage => :file_system, 
                 :max_size => 5.megabytes,
                 :resize_to => '800x600>',
                 :thumbnails => { :thumb => '120x90' },
								 :processor => :rmagick

  validates_as_attachment
end