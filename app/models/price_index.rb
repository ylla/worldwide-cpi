class PriceIndex < ActiveRecord::Base
  belongs_to :region
  validates :region_id, presence: true
  validates :year, presence: true
end
