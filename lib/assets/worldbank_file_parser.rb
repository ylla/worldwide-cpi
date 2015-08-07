def file_parser
	doc = Nokogiri::XML(File.open("app/assets/aruba.xml")) do |config|
		config.options = Nokogiri::XML::ParseOptions::NOBLANKS | Nokogiri::XML::ParseOptions::NOENT
	end

	# Add some kind of entry here to replace the 1 in each xpath call
	entry = 1
	
	temp_code = (doc.xpath("//record[1]/field/@key")[0].text).downcase
	@region = Region.find_by(code: temp_code)

	if @region.blank?
		region_name = doc.xpath("//record[1]/field[1]").text
		region_code = temp_code
		@region = Region.new(name: region_name, code: region_code)
		@region.save
	else
		@region
	end

	(temp_value = doc.xpath("//record[1]/field[@name=\"Value\"]").text).to_f

	if !temp_value.blank?
		index_year = Date.new(doc.xpath("//record[1]/field[@name=\"Year\"]").text.to_i)
		index_value = temp_value
		@region.price_indices.build(year: index_year, value: temp_value)
	end
	@region.save
end