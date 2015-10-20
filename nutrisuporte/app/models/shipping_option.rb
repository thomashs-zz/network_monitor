class ShippingOption
	attr_accessor :name, :days, :price, :message
	def initialize(params)
		params.each do |k,v|
			send("#{k}=",v)
		end
	end
end