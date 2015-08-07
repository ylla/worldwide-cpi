task :import_worldbank, [:file] => :environment do |t, args|
	puts "Loading file..."
	doc = Nokogiri::XML(File.open("#{args.file}")) do |config|
		config.options = Nokogiri::XML::ParseOptions::NOBLANKS | Nokogiri::XML::ParseOptions::NOENT
	end

	# Add some kind of entry here to replace the 1 in each xpath call
	records = doc.xpath("//record")
	puts "#{Datetime.current} - Iterating over #{records.length} records in file..."
	records.each do |record|
	
		temp_code = (record.xpath("field/@key")[0].text).downcase
		@region = Region.find_by(code: temp_code)

		if @region.blank?
			region_name = record.xpath("field[1]").text
			region_code = temp_code
			@region = Region.new(name: region_name, code: region_code)
			@region.save 
		else
			@region
		end

		(temp_value = record.xpath("field[@name=\"Value\"]").text).to_f

		if !temp_value.blank?
			index_year = Date.new(record.xpath("field[@name=\"Year\"]").text.to_i)
			index_value = temp_value
			@region.price_indices.build(year: index_year, value: temp_value)
		end
		@region.save
	end
	puts "#{Datetime.current} - #{PriceIndex.count} records loaded"
end