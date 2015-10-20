ActiveAdmin.register ProductSubscription do

	filter :product
	filter :name
	filter :email

	index do 
		column :product
		column :name
		column :email
		default_actions
	end

	show do
		attributes_table do 
			row :product
			row :name
			row :email
		end
	end

end