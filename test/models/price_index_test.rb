require 'test_helper'

class PriceIndexTest < ActiveSupport::TestCase
  
  def setup
  	@region = regions(:one)
  	@price_index = @region.price_indices.build(year: Date.new(2000, 02, 03), value: 0.345)
  end

  test "should be valid" do
  	assert @price_index.valid?
  end

  test "region id should be present" do
  	@price_index.region_id = nil
  	assert_not @price_index.valid?
  end

  test "value should be a float or nil" do
  	@price_index.value = 1.2
  	assert @price_index.value.is_a? Float
  	@price_index.value = nil
  	assert @price_index.value.nil?, "is not nil"
  end

	# Test to verify that year is a date

	# test "associated price_indices should be destroyed" do
	#		@region.save
	#		region.price_indices.create!(year: Date.new(1900), value: 3.4556788)
	#		assert_difference 'PriceIndex.count', -1 do
	#			@region.destroy
	#		end
	# end
end
