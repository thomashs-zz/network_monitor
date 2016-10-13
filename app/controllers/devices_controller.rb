class DevicesController < ApplicationController
	def new
		@device = Device.new
	end
	def create
		@device = Device.new(params[:device])
		if @device.save
			redirect_to device_path(@device)
		else
			render action: :new
		end
	end
	def edit
		@device = Device.find(params[:id])
	end
	def update
		@device = Device.find(params[:id])
		if @device.update_attributes(params[:device])
			redirect_to device_path(@device)
		else
			render :edit
		end
	end
	def show
		@device = Device.find(params[:id])
	end
	def destroy
		@device = Device.find(params[:id])
		@device.destroy
		redirect_to root_path
	end
end