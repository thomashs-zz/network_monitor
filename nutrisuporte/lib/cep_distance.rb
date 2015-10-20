class CepDistance
	def self.calculate(from,to)
		url = "http://maps.googleapis.com/maps/api/distancematrix/xml?origins=#{from}&destinations=#{to}&mode=CAR&language=pt-BR&sensor=false"
		begin
			xml_data = Net::HTTP.get_response(URI.parse(url)).body
			BigDecimal.new(Hash.from_xml(xml_data)['DistanceMatrixResponse']['row']['element']['distance']['text'].gsub(' km','').gsub(',','.'))
		rescue
			nil
		end
	end
end