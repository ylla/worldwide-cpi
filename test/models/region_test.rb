require 'test_helper'

class RegionTest < ActiveSupport::TestCase

	def setup
		@region = Region.new(name: "Equestria", code: "EQA")
	end

	test "should be valid" do
		assert @region.valid?
	end

	test "name should be present" do
		@region.name = "    "
		assert_not @region.valid?
	end

	test "code should be present" do
		@region.code = "    "
		assert_not @region.valid?
	end

	test "name should not be too long" do
		@region.name = "a" * 256
		assert_not @region.valid?
	end

	test "code should not be too long" do
		@region.code = "a" * 4
		assert_not @region.valid?
	end

	test "code should be unique" do
		duplicate_region = @region.dup
		@region.save
		assert_not duplicate_region.valid?, "Warning: Same region code exists twice"
	end

	test "code should be saved as downcase" do
		mixed_case_code = 'XyZ'
		@region.code = mixed_case_code
		@region.save
		assert_equal mixed_case_code.downcase, @region.reload.code
	end
end
