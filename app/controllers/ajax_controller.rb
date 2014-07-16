class AjaxController < ApplicationController
	def run
		render json: SnmpHelper.run(params[:id])
	end
end