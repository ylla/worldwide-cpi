class Region < ActiveRecord::Base
	before_save { code.downcase! }
	validates :name, presence: true, length: { maximum: 255 }
	validates :code, presence: true, length: { maximum: 3 },
						uniqueness: { case_sensitive: false }
end
