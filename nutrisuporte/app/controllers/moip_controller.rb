class MoipController < ActionController::Base
	def nasp
		MOIP_LOGGER.info(params)
		params.keep_if{ |k,v| MoipNasp.new.attributes.include?(k.to_s) }
		params.with_indifferent_access
		MoipNasp.new(params).save
		render :nothing => true, :status => 200, :content_type => 'text/html'
	end
end