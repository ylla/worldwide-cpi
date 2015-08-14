task :import_worldbank, [:file] => :environment do |t, args|
	puts "Loading file..."
	doc = Nokogiri::XML(File.open("#{args.file}")) do |config|
		config.options = Nokogiri::XML::ParseOptions::NOBLANKS | 
		                 Nokogiri::XML::ParseOptions::NOENT
	end

	records = doc.xpath("/Root/data/record")
	puts "Iterating over #{records.count} records in file..."
	region = ""

	records.each do |record|
		temp_code = (record.xpath("field/@key")[0].text).downcase
		if temp_code != region
			region = Region.find_by(code: temp_code)
			if region.blank?
				region = Region.new(name: record.xpath("field[1]").text, code: temp_code)
				region.save
			end
		end

		temp_value = (record.xpath("field[@name=\"Value\"]").text).to_f

		if !temp_value.blank?
			price_index = region.price_indices.build(year: Date.new(record.xpath("field[@name=\"Year\"]").text.to_i), value: temp_value)
			price_index.save
		end
	end
	puts "#{PriceIndex.count} records loaded"
end
