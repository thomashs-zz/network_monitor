class RegistrationsController < Devise::RegistrationsController
	require 'brazilian_states'
	def new
		build_resource
		resource.user_addresses.build
	end
end